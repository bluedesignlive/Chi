#ifndef SMARTUI_H
#define SMARTUI_H

#include <QtQuick/QQuickPaintedItem>
#include <QtQml/qqml.h>   // Needed for QML_ELEMENT

class SmartUi : public QQuickPaintedItem
{
    Q_OBJECT
    QML_ELEMENT
    Q_DISABLE_COPY(SmartUi)

public:
    explicit SmartUi(QQuickItem *parent = nullptr);
    void paint(QPainter *painter) override;
    ~SmartUi() override;
};

#endif // SMARTUI_H
