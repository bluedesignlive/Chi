#include "fileiconprovider.h"

#include <QHash>
#include <QString>
#include <QLatin1String>

using namespace Qt::StringLiterals;

using Map = QHash<QString, QString>;

static const Map &extMap()
{
    static const Map m = [] {
        Map m;
        auto add = [&](const std::initializer_list<const char *> &exts,
                       const QString &icon) {
            for (const char *e : exts)
                m.insert(QLatin1String(e), icon);
        };

        add({"png","jpg","jpeg","gif","bmp","webp","svg","ico",
             "tiff","tif","avif","heic","heif","raw","cr2","nef","arw"},
            u"image"_s);
        add({"pdf"},                      u"picture_as_pdf"_s);
        add({"doc","docx","odt","rtf"},   u"description"_s);
        add({"txt","md","markdown","rst"},u"description"_s);
        add({"xls","xlsx","ods","csv"},   u"table_chart"_s);
        add({"ppt","pptx","odp","key"},   u"slideshow"_s);
        add({"zip","tar","gz","bz2","xz","7z","rar","zst","lz4"},
            u"folder_zip"_s);
        add({"mp3","wav","flac","m4a","ogg","opus","aac","wma","alac"},
            u"music_note"_s);
        add({"mp4","mkv","avi","mov","webm","wmv","flv","m4v","ts"},
            u"movie"_s);
        add({"js","ts","jsx","tsx","py","rb","rs","go","java","kt",
             "c","h","cpp","hpp","cc","hh","cs","swift","zig",
             "qml","html","htm","css","scss","sass","less","vue","svelte"},
            u"code"_s);
        add({"json","xml","yaml","yml","toml","ini","cfg","conf"},
            u"data_object"_s);
        add({"sh","bash","zsh","fish","ps1","bat","cmd"},
            u"terminal"_s);
        add({"lock"},                     u"lock"_s);
        add({"log"},                      u"article"_s);
        add({"iso","img","dmg"},          u"disc_full"_s);
        add({"exe","msi","app","deb","rpm","flatpak","snap","appimage"},
            u"apps"_s);
        add({"ttf","otf","woff","woff2"}, u"font_download"_s);

        return m;
    }();
    return m;
}

static const Map &mimeMap()
{
    static const Map m = {
        { u"image/"_s,                    u"image"_s },
        { u"video/"_s,                    u"movie"_s },
        { u"audio/"_s,                    u"music_note"_s },
        { u"text/"_s,                     u"description"_s },
        { u"application/pdf"_s,           u"picture_as_pdf"_s },
        { u"application/zip"_s,           u"folder_zip"_s },
        { u"application/x-tar"_s,         u"folder_zip"_s },
        { u"application/gzip"_s,          u"folder_zip"_s },
        { u"application/x-7z-compressed"_s, u"folder_zip"_s },
        { u"application/x-rar-compressed"_s, u"folder_zip"_s },
        { u"application/json"_s,          u"data_object"_s },
        { u"application/xml"_s,           u"data_object"_s },
        { u"application/javascript"_s,    u"code"_s },
        { u"application/x-executable"_s,  u"apps"_s },
        { u"application/x-sharedlib"_s,   u"code"_s },
        { u"inode/directory"_s,           u"folder"_s },
        { u"inode/symlink"_s,             u"link"_s },
    };
    return m;
}

FileIconProvider::FileIconProvider(QObject *parent)
    : QObject(parent)
{}

QString FileIconProvider::iconForExtension(const QString &ext)
{
    const QString lower = ext.toLower();
    const auto &m = extMap();
    auto it = m.constFind(lower);
    return (it != m.constEnd()) ? it.value() : u"insert_drive_file"_s;
}

QString FileIconProvider::iconForMime(const QString &mimeName)
{
    const auto &m = mimeMap();

    auto it = m.constFind(mimeName);
    if (it != m.constEnd()) return it.value();

    for (auto pit = m.constBegin(); pit != m.constEnd(); ++pit) {
        if (pit.key().endsWith(u'/') && mimeName.startsWith(pit.key()))
            return pit.value();
    }

    return u"insert_drive_file"_s;
}

QString FileIconProvider::iconForFile(const QString &fileName)
{
    const int dot = fileName.lastIndexOf(u'.');
    if (dot < 0) return u"insert_drive_file"_s;
    return iconForExtension(fileName.mid(dot + 1));
}
