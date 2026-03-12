import QtQuick
import QtQuick.Layouts
import "../Buttons" as Buttons
import "../theme" as Theme

Dialog {
    id: root

    property string confirmButtonText: "OK"
    property string dismissButtonText: ""
    property string confirmButtonVariant: "text"
    property string dismissButtonVariant: "text"
    property bool destructive: false

    type: "basic"
    size: "small"

    actions: [
        Buttons.Button {
            visible: dismissButtonText !== ""
            text: dismissButtonText
            variant: dismissButtonVariant
            onClicked: root.reject()
        },
        Buttons.Button {
            text: confirmButtonText
            variant: confirmButtonVariant
            onClicked: root.accept()
        }
    ]
}
