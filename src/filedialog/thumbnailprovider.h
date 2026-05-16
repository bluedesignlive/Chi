#pragma once

#include <QQuickAsyncImageProvider>
#include <QQuickImageResponse>
#include <QImage>
#include <QThreadPool>
#include <QString>

class ThumbRunnable;

class ThumbnailResponse : public QQuickImageResponse
{
    Q_OBJECT
public:
    ThumbnailResponse(const QString &filePath, const QSize &requestedSize,
                      QThreadPool *pool);

    QQuickTextureFactory *textureFactory() const override;

    static QString cacheDir();
    static QString cacheKey(const QString &path, const QSize &size);
    static QImage  generate(const QString &path, const QSize &size);

    QImage m_image;

    friend class ThumbRunnable;
};

class ThumbnailProvider : public QQuickAsyncImageProvider
{
public:
    ThumbnailProvider();

    QQuickImageResponse *requestImageResponse(
        const QString &id, const QSize &requestedSize) override;

private:
    QThreadPool m_pool;
};
