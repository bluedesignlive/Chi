#include "register_types.h"
#include "filelistmodel.h"
#include "thumbnailprovider.h"
#include "fileiconprovider.h"

#include <QQmlEngine>
#include <QtQml>

using namespace Qt::StringLiterals;

void registerFileDialogTypes(const char *uri)
{
    qmlRegisterType<FileListModel>(uri, 1, 0, "ChiFileDialogModel");

    qmlRegisterSingletonType<FileIconProvider>(
        uri, 1, 0, "ChiFileIconProvider",
        [](QQmlEngine *, QJSEngine *) -> QObject * {
            return new FileIconProvider;
        });
}

void initializeFileDialogEngine(QQmlEngine *engine)
{
    engine->addImageProvider(u"thumb"_s, new ThumbnailProvider);
}
