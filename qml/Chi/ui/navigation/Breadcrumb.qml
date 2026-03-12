import QtQuick
import QtQuick.Layouts
import "../theme" as Theme

Item {
    id: root

    property var items: []                   // [{text: "", icon: "", path: ""}]
    property string separator: "›"
    property bool showHome: true
    property string homeIcon: "🏠"
    property bool enabled: true

    signal itemClicked(int index, var item)
    signal homeClicked()

    implicitWidth: breadcrumbRow.implicitWidth
    implicitHeight: 32

    property var colors: Theme.ChiTheme.colors

    Row {
        id: breadcrumbRow
        anchors.verticalCenter: parent.verticalCenter
        spacing: 4

        // Home button
        Item {
            visible: showHome
            width: 32
            height: 32

            Rectangle {
                anchors.fill: parent
                radius: 4
                color: colors.onSurface
                opacity: homeMouse.containsMouse ? 0.08 : 0
            }

            Text {
                anchors.centerIn: parent
                text: homeIcon
                font.pixelSize: 16
                color: colors.onSurfaceVariant
            }

            MouseArea {
                id: homeMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                enabled: root.enabled
                onClicked: homeClicked()
            }
        }

        Text {
            visible: showHome && items.length > 0
            text: separator
            font.family: "Roboto"
            font.pixelSize: 14
            color: colors.onSurfaceVariant
            anchors.verticalCenter: parent.verticalCenter
        }

        // Breadcrumb items
        Repeater {
            model: items

            Row {
                spacing: 4

                Item {
                    width: crumbContent.implicitWidth + 16
                    height: 32

                    property bool isLast: index === items.length - 1

                    Rectangle {
                        anchors.fill: parent
                        radius: 4
                        color: colors.onSurface
                        opacity: crumbMouse.containsMouse && !isLast ? 0.08 : 0
                    }

                    Row {
                        id: crumbContent
                        anchors.centerIn: parent
                        spacing: 6

                        Text {
                            visible: modelData.icon && modelData.icon !== ""
                            text: modelData.icon
                            font.pixelSize: 14
                            color: isLast ? colors.onSurface : colors.onSurfaceVariant
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Text {
                            text: modelData.text
                            font.family: "Roboto"
                            font.pixelSize: 14
                            font.weight: isLast ? Font.Medium : Font.Normal
                            color: isLast ? colors.onSurface : colors.onSurfaceVariant
                            anchors.verticalCenter: parent.verticalCenter

                            Behavior on color {
                                ColorAnimation { duration: 150 }
                            }
                        }
                    }

                    MouseArea {
                        id: crumbMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: !isLast ? Qt.PointingHandCursor : Qt.ArrowCursor
                        enabled: root.enabled && !isLast
                        onClicked: itemClicked(index, modelData)
                    }
                }

                Text {
                    visible: index < items.length - 1
                    text: separator
                    font.family: "Roboto"
                    font.pixelSize: 14
                    color: colors.onSurfaceVariant
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }

    Accessible.role: Accessible.List
    Accessible.name: "Breadcrumb navigation"
}
