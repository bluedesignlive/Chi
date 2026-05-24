import QtQuick
import QtQuick.Layouts
import "../Buttons" as Buttons
import "../../theme" as Theme

Dialog {
 id: root

 property string message: ""

 // Convenience: wire message into Dialog's supportingText
 supportingText: message

 property string confirmButtonText: "Confirm"
 property string dismissButtonText: "Cancel"
 property bool destructive: false

 type: "basic"
 size: "small"

 property var colors: Theme.ChiTheme.colors

 // Forward Dialog's accepted/rejected as convenience signals
 // so users can do: onAccepted: { ... } onRejected: { ... }
 signal confirmed
 signal dismissed

 onAccepted: root.confirmed()
 onRejected: root.dismissed()

 actions: [
 Buttons.Button {
 text: dismissButtonText
 variant: "text"
 onClicked: root.reject()
 },
 Buttons.Button {
 text: confirmButtonText
 variant: destructive ? "filled" : "text"
 property color _btnColor: destructive ? colors.error : colors.primary
 onClicked: root.accept()
 }
 ]
}
