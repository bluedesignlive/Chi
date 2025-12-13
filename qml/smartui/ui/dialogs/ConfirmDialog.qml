import QtQuick
import QtQuick.Layouts
import "../Buttons" as Buttons
import "../../theme" as Theme

Dialog {
    id: root

    property string confirmButtonText: "Confirm"
    property string dismissButtonText: "Cancel"
    property bool destructive: false

    type: "basic"
    size: "small"

    property var colors: Theme.ChiTheme.colors

    actions: [
        Buttons.Button {
            text: dismissButtonText
            variant: "text"
            onClicked: root.reject()
        },
        Buttons.Button {
            text: confirmButtonText
            variant: "text"
            // TODO: Add destructive color support to Button
            onClicked: root.accept()
        }
    ]
}
