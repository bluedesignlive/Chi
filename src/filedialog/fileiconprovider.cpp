#include "fileiconprovider.h"
#include <QMimeDatabase>
#include <QMimeType>
#include <QHash>
#include <QFileInfo>

using namespace Qt::StringLiterals;

// ── Freedesktop generic icon name → Material Symbols ────────
// This is the ONLY manually maintained list. ~40 entries covering
// ALL file types via the freedesktop icon naming specification.
// New file types are automatically handled by heuristic fallback.

static const QHash<QString, QString> &genericIconMap()
{
    static const QHash<QString, QString> m = [] {
        QHash<QString, QString> m;
        auto add = [&](std::initializer_list<const char*> names, const QString &icon) {
            for (const char *n : names) m.insert(QLatin1String(n), icon);
        };

        add({"audio-x-generic"},                u"music_note"_s);
        add({"video-x-generic"},                u"movie"_s);
        add({"image-x-generic"},                u"image"_s);
        add({"font-x-generic"},                 u"font_download"_s);
        add({"inode-directory"},                u"folder"_s);
        add({"inode-symlink"},                  u"link"_s);

        add({"text-x-generic","text-plain","text-html",
             "text-x-readme","text-x-changelog"},  u"description"_s);
        add({"x-office-document"},              u"description"_s);
        add({"x-office-spreadsheet"},           u"table_chart"_s);
        add({"x-office-presentation"},          u"slideshow"_s);
        add({"application-pdf"},                u"picture_as_pdf"_s);
        add({"application-vnd.oasis.opendocument.text",
             "application-vnd.oasis.opendocument.spreadsheet",
             "application-vnd.oasis.opendocument.presentation"}, u"description"_s);

        add({"text-x-script","text-x-python","text-x-perl",
             "text-x-ruby","text-x-java","text-x-csrc",
             "text-x-c++src","text-x-go","text-x-rust",
             "text-x-sql","text-x-tex","text-x-makefile",
             "text-x-diff","text-x-patch",
             "text-x-gettext-translation"},     u"code"_s);
        add({"application-javascript","application-x-python",
             "application-x-ruby","application-x-perl",
             "application-x-php","application-x-shellscript",
             "application-x-lua"},              u"code"_s);
        add({"application-x-executable",
             "application-x-sharedlib"},        u"apps"_s);

        add({"application-json","application-xml","text-xml",
             "text-x-opml+xml","application-rss+xml",
             "application-atom+xml"},           u"data_object"_s);

        add({"application-zip","application-x-tar","application-gzip",
             "application-x-bzip2","application-x-xz",
             "application-x-7z-compressed",
             "application-x-rar-compressed",
             "application-x-compressed-tar",
             "application-x-bzip-compressed-tar",
             "package-x-generic"},              u"folder_zip"_s);

        return m;
    }();
    return m;
}

// ── Constructor ─────────────────────────────────────────────

FileIconProvider::FileIconProvider(QObject *parent) : QObject(parent) {}

// ── Internal: MIME name + generic icon name → Material icon ─

static QString mimeToIcon(const QString &mimeName, const QString &genericName)
{
    // 1. Fast prefix match (broad categories)
    if (mimeName.startsWith(u"image/"_s)) return u"image"_s;
    if (mimeName.startsWith(u"video/"_s)) return u"movie"_s;
    if (mimeName.startsWith(u"audio/"_s)) return u"music_note"_s;
    if (mimeName.startsWith(u"font/"_s))  return u"font_download"_s;
    if (mimeName == u"inode/directory"_s)  return u"folder"_s;
    if (mimeName == u"inode/symlink"_s)    return u"link"_s;
    if (mimeName == u"application/pdf"_s)  return u"picture_as_pdf"_s;

    // 2. Text/code detection via MIME name
    if (mimeName.startsWith(u"text/"_s)) {
        if (mimeName.contains(u"script"_s) || mimeName.contains(u"python"_s) ||
            mimeName.contains(u"ruby"_s) || mimeName.contains(u"java"_s) ||
            mimeName.contains(u"csrc"_s) || mimeName.contains(u"c++src"_s) ||
            mimeName.contains(u"rust"_s) || mimeName.contains(u"go"_s) ||
            mimeName.contains(u"sql"_s) || mimeName.contains(u"tex"_s))
            return u"code"_s;
        if (mimeName.contains(u"xml"_s) || mimeName.contains(u"json"_s) ||
            mimeName.contains(u"yaml"_s) || mimeName.contains(u"toml"_s))
            return u"data_object"_s;
        return u"description"_s;
    }

    // 3. Application MIME heuristic
    if (mimeName.contains(u"javascript"_s) || mimeName.contains(u"typescript"_s) ||
        mimeName.contains(u"python"_s) || mimeName.contains(u"ruby"_s) ||
        mimeName.contains(u"perl"_s) || mimeName.contains(u"php"_s) ||
        mimeName.contains(u"lua"_s) || mimeName.contains(u"shell"_s))
        return u"code"_s;
    if (mimeName.contains(u"zip"_s) || mimeName.contains(u"tar"_s) ||
        mimeName.contains(u"compress"_s) || mimeName.contains(u"archive"_s) ||
        mimeName.contains(u"bzip"_s) || mimeName.contains(u"xz"_s) ||
        mimeName.contains(u"rar"_s) || mimeName.contains(u"7z"_s))
        return u"folder_zip"_s;
    if (mimeName.contains(u"json"_s) || mimeName.contains(u"xml"_s))
        return u"data_object"_s;
    if (mimeName.contains(u"executable"_s) || mimeName.contains(u"sharedlib"_s))
        return u"apps"_s;

    // 4. Freedesktop generic icon name → Material Symbols
    if (!genericName.isEmpty()) {
        const auto &gmap = genericIconMap();
        auto it = gmap.constFind(genericName);
        if (it != gmap.constEnd()) return it.value();

        // Heuristic on generic name
        if (genericName.startsWith(u"audio"_s))   return u"music_note"_s;
        if (genericName.startsWith(u"video"_s))   return u"movie"_s;
        if (genericName.startsWith(u"image"_s))   return u"image"_s;
        if (genericName.startsWith(u"text"_s))    return u"description"_s;
        if (genericName.startsWith(u"font"_s))    return u"font_download"_s;
        if (genericName.startsWith(u"inode"_s))   return u"folder"_s;
    }

    return u"insert_drive_file"_s;
}

// ── Public API ──────────────────────────────────────────────

QString FileIconProvider::iconForFile(const QString &fileName)
{
    QMimeDatabase db;
    QMimeType mime = db.mimeTypeForFile(fileName, QMimeDatabase::MatchExtension);
    if (mime.isDefault()) {
        // MIME database has no entry — try content-based or return generic
        QMimeType contentMime = db.mimeTypeForFile(fileName, QMimeDatabase::MatchContent);
        if (!contentMime.isDefault())
            return mimeToIcon(contentMime.name(), contentMime.genericIconName());
        return u"insert_drive_file"_s;
    }
    return mimeToIcon(mime.name(), mime.genericIconName());
}

QString FileIconProvider::iconForMime(const QString &mimeName)
{
    QMimeDatabase db;
    QMimeType mime = db.mimeTypeForName(mimeName);
    return mimeToIcon(mimeName, mime.isValid() ? mime.genericIconName() : QString());
}

QString FileIconProvider::iconForExtension(const QString &ext)
{
    return iconForFile(u"file."_s + ext.toLower());
}
