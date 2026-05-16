#include "thumbnailprovider.h"

#include <QStandardPaths>
#include <QDir>
#include <QFile>
#include <QFileInfo>
#include <QImageReader>
#include <QCryptographicHash>
#include <QCoreApplication>
#include <QThreadPool>
#include <QRunnable>
#include <QMimeDatabase>
#include <QProcess>

using namespace Qt::StringLiterals;

ThumbnailProvider::ThumbnailProvider()
{
    m_pool.setMaxThreadCount(4);
    m_pool.setExpiryTimeout(30000);
    QDir().mkpath(ThumbnailResponse::cacheDir());
}

QQuickImageResponse *ThumbnailProvider::requestImageResponse(
    const QString &id, const QSize &requestedSize)
{
    return new ThumbnailResponse(id, requestedSize, &m_pool);
}

// ── Runnable ────────────────────────────────────────────────

class ThumbRunnable : public QRunnable
{
public:
    ThumbRunnable(ThumbnailResponse *resp, const QString &path,
                  const QSize &size)
        : m_resp(resp), m_path(path), m_size(size) {}

    void run() override
    {
        const QString cDir  = ThumbnailResponse::cacheDir();
        const QString cFile = cDir + u'/'
            + ThumbnailResponse::cacheKey(m_path, m_size) + u".jpg";

        // ── Disk cache hit — instant, zero CPU ─────────────
        if (QFile::exists(cFile)) {
            m_resp->m_image = QImage(cFile);
            if (!m_resp->m_image.isNull()) {
                emit m_resp->finished();
                return;
            }
        }

        // ── Detect MIME ────────────────────────────────────
        QMimeDatabase db;
        QMimeType mime = db.mimeTypeForFile(m_path);
        const QString mimeName = mime.name();

        if (mimeName.startsWith(u"image/"_s)) {
            m_resp->m_image = ThumbnailResponse::generate(m_path, m_size);
        }
        else if (mimeName.startsWith(u"video/"_s)) {
            m_resp->m_image = extractMediaThumb(m_path, m_size, true);
        }
        else if (mimeName.startsWith(u"audio/"_s)) {
            m_resp->m_image = extractMediaThumb(m_path, m_size, false);
        }
        // else: no thumbnail, emit finished() below, QML shows icon

        // ── Atomic disk cache write ────────────────────────
        if (!m_resp->m_image.isNull()) {
            const QString tmp = cFile + u'.'
                + QString::number(QCoreApplication::applicationPid())
                + u".tmp";
            if (m_resp->m_image.save(tmp, "JPEG", 90))
                QFile::rename(tmp, cFile);
            else
                QFile::remove(tmp);
        }

        emit m_resp->finished();
    }

private:
    static QImage extractMediaThumb(const QString &path,
                                    const QSize &size, bool isVideo)
    {
        QString ffmpeg = QStandardPaths::findExecutable(u"ffmpeg"_s);
        if (ffmpeg.isEmpty()) ffmpeg = QStandardPaths::findExecutable(u"avconv"_s);
        if (ffmpeg.isEmpty()) return {};

        const QString tmpPath = QDir::tempPath()
            + u"/chi_thumb_"_s
            + QString::number(QCoreApplication::applicationPid())
            + u'_' + QString::number(quintptr(QThread::currentThread()))
            + u".jpg"_s;

        QStringList args;
        if (isVideo) {
            args << u"-ss"_s << u"2"_s
                 << u"-i"_s << path
                 << u"-an"_s << u"-vframes"_s << u"1"_s
                 << u"-vf"_s << (u"scale="_s + QString::number(size.width())
                                + u":"_s + QString::number(size.height())
                                + u":force_original_aspect_ratio=decrease"_s)
                 << u"-y"_s << tmpPath;
        } else {
            args << u"-i"_s << path
                 << u"-an"_s << u"-vframes"_s << u"1"_s
                 << u"-vf"_s << (u"scale="_s + QString::number(size.width())
                                + u":"_s + QString::number(size.height())
                                + u":force_original_aspect_ratio=decrease"_s)
                 << u"-y"_s << tmpPath;
        }

        QProcess proc;
        proc.setProcessChannelMode(QProcess::SeparateChannels);
        proc.start(ffmpeg, args);
        proc.waitForFinished(5000);

        QImage img;
        if (proc.exitCode() == 0 && QFile::exists(tmpPath)) {
            img = QImage(tmpPath);
            QFile::remove(tmpPath);
        }
        return img;
    }

    ThumbnailResponse *m_resp;
    QString m_path;
    QSize   m_size;
};

// ── Response / Provider ─────────────────────────────────────

ThumbnailResponse::ThumbnailResponse(const QString &filePath,
                                     const QSize &requestedSize,
                                     QThreadPool *pool)
{
    const QSize size = requestedSize.isValid() ? requestedSize : QSize(256, 256);
    auto *runnable = new ThumbRunnable(this, filePath, size);
    runnable->setAutoDelete(true);
    pool->start(runnable);
}

QQuickTextureFactory *ThumbnailResponse::textureFactory() const
{
    if (m_image.isNull()) return nullptr;
    return QQuickTextureFactory::textureFactoryForImage(m_image);
}

QString ThumbnailResponse::cacheDir()
{
    return QStandardPaths::writableLocation(QStandardPaths::CacheLocation)
           + u"/thumbnails"_s;
}

QString ThumbnailResponse::cacheKey(const QString &path, const QSize &size)
{
    const QByteArray raw = path.toUtf8()
        + '|' + QByteArray::number(size.width())
        + 'x' + QByteArray::number(size.height());
    return QString::fromLatin1(
        QCryptographicHash::hash(raw, QCryptographicHash::Sha256).toHex());
}

QImage ThumbnailResponse::generate(const QString &path, const QSize &size)
{
    // QImageReader uses Qt's platform image plugins:
    //   png, jpg, gif, webp, avif, heic/heif, svg, bmp, ico, tiff, pbm, pgm, ppm, xbm, xpm
    // These are ALL the formats Qt was built with — no manual mapping.

    // Path 1: Scale-during-decode (memory efficient for large images)
    QImageReader reader(path);
    reader.setAutoTransform(true);

    const QSize original = reader.size();
    if (original.isValid()
        && (original.width() > size.width() || original.height() > size.height())) {
        reader.setScaledSize(original.scaled(size, Qt::KeepAspectRatio));
    }

    QImage img = reader.read();
    if (!img.isNull()) return img;

    // Path 2: Full decode then scale (some plugins don't support scaled read)
    QImageReader reader2(path);
    reader2.setAutoTransform(true);
    img = reader2.read();
    if (!img.isNull())
        return img.scaled(size, Qt::KeepAspectRatio, Qt::SmoothTransformation);

    return {};
}
