// library/ui/Buttons/IconButtonShowcase.qml - COMPREHENSIVE VARIATIONS
import QtQuick
import QtQuick.Controls.Basic
import smartui 1.0 as Su

Rectangle {
    width: 1400
    height: 900
    color: Su.ChiTheme.colors.background
    radius: 26

    Behavior on color {
        ColorAnimation { duration: 200 }
    }

    Flickable {
        anchors.fill: parent
        anchors.margins: 2
        contentHeight: mainColumn.height + 80
        clip: true

        Column {
            id: mainColumn
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - 80
            spacing: 40
            topPadding: 40
            bottomPadding: 40

            Row {
                width: parent.width
                spacing: 20

                Text {
                    text: "Icon Buttons"
                    font.family: "Roboto"
                    font.pixelSize: 32
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onBackground
                    anchors.verticalCenter: parent.verticalCenter

                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }
                }

                Item { width: 100; height: 1 }

                Row {
                    spacing: 10
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        text: "☀️"
                        font.pixelSize: 20
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Switch {
                        checked: Su.ChiTheme.isDarkMode
                        onToggled: Su.ChiTheme.isDarkMode = !Su.ChiTheme.isDarkMode
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        text: "🌙"
                        font.pixelSize: 20
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }

            Text {
                text: "Icon-only buttons for actions. Clean, consistent flat icons."
                font.pixelSize: 14
                color: Su.ChiTheme.colors.onSurfaceVariant
                Behavior on color { ColorAnimation { duration: 200 } }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: Su.ChiTheme.colors.outline
                opacity: 0.3
            }

            // WIDTH MODES - SMALL SIZE
            Column {
                width: parent.width
                spacing: 20

                Text {
                    text: "Width Modes - Small (40px height)"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Row {
                    spacing: 40

                    Column {
                        spacing: 8
                        Su.IconButton {
                            icon: "✕"
                            variant: "filled"
                            size: "small"
                            widthMode: "narrow"
                            tooltip: "Close (Narrow)"
                        }
                        Text {
                            text: "Narrow 32w"
                            font.pixelSize: 11
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.IconButton {
                            icon: "✕"
                            variant: "filled"
                            size: "small"
                            widthMode: "default"
                            tooltip: "Close (Default)"
                        }
                        Text {
                            text: "Default 40w"
                            font.pixelSize: 11
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.IconButton {
                            icon: "✕"
                            variant: "filled"
                            size: "small"
                            widthMode: "wide"
                            tooltip: "Close (Wide)"
                        }
                        Text {
                            text: "Wide 52w"
                            font.pixelSize: 11
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: Su.ChiTheme.colors.outline
                opacity: 0.3
            }

            // WIDTH MODES - LARGE SIZE
            Column {
                width: parent.width
                spacing: 20

                Text {
                    text: "Width Modes - Large (96px height)"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Grid {
                    columns: 3
                    columnSpacing: 40
                    rowSpacing: 30

                    // TONAL VARIANT
                    Column {
                        spacing: 8
                        Text {
                            text: "Tonal - Narrow"
                            font.pixelSize: 12
                            font.weight: Font.Medium
                            color: Su.ChiTheme.colors.onBackground
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        Su.IconButton {
                            icon: "+"
                            variant: "tonal"
                            size: "large"
                            widthMode: "narrow"
                            tooltip: "Add (Tonal Narrow)"
                        }
                        Text {
                            text: "88w × 96h"
                            font.pixelSize: 11
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Text {
                            text: "Tonal - Default"
                            font.pixelSize: 12
                            font.weight: Font.Medium
                            color: Su.ChiTheme.colors.onBackground
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        Su.IconButton {
                            icon: "+"
                            variant: "tonal"
                            size: "large"
                            widthMode: "default"
                            tooltip: "Add (Tonal Default)"
                        }
                        Text {
                            text: "96w × 96h"
                            font.pixelSize: 11
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Text {
                            text: "Tonal - Wide"
                            font.pixelSize: 12
                            font.weight: Font.Medium
                            color: Su.ChiTheme.colors.onBackground
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        Su.IconButton {
                            icon: "+"
                            variant: "tonal"
                            size: "large"
                            widthMode: "wide"
                            tooltip: "Add (Tonal Wide)"
                        }
                        Text {
                            text: "108w × 96h"
                            font.pixelSize: 11
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    // OUTLINED VARIANT
                    Column {
                        spacing: 8
                        Text {
                            text: "Outlined - Narrow"
                            font.pixelSize: 12
                            font.weight: Font.Medium
                            color: Su.ChiTheme.colors.onBackground
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        Su.IconButton {
                            icon: "→"
                            variant: "outlined"
                            size: "large"
                            widthMode: "narrow"
                            tooltip: "Next (Outlined Narrow)"
                        }
                        Text {
                            text: "88w × 96h"
                            font.pixelSize: 11
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Text {
                            text: "Outlined - Default"
                            font.pixelSize: 12
                            font.weight: Font.Medium
                            color: Su.ChiTheme.colors.onBackground
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        Su.IconButton {
                            icon: "→"
                            variant: "outlined"
                            size: "large"
                            widthMode: "default"
                            tooltip: "Next (Outlined Default)"
                        }
                        Text {
                            text: "96w × 96h"
                            font.pixelSize: 11
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Text {
                            text: "Outlined - Wide"
                            font.pixelSize: 12
                            font.weight: Font.Medium
                            color: Su.ChiTheme.colors.onBackground
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        Su.IconButton {
                            icon: "→"
                            variant: "outlined"
                            size: "large"
                            widthMode: "wide"
                            tooltip: "Next (Outlined Wide)"
                        }
                        Text {
                            text: "108w × 96h"
                            font.pixelSize: 11
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: Su.ChiTheme.colors.outline
                opacity: 0.3
            }

            // WIDTH MODES - XLARGE SIZE
            Column {
                width: parent.width
                spacing: 20

                Text {
                    text: "Width Modes - XLarge (136px height)"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Grid {
                    columns: 3
                    columnSpacing: 40
                    rowSpacing: 30

                    Column {
                        spacing: 8
                        Text {
                            text: "Narrow"
                            font.pixelSize: 12
                            font.weight: Font.Medium
                            color: Su.ChiTheme.colors.onBackground
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        Su.IconButton {
                            icon: "✓"
                            variant: "tonal"
                            size: "xlarge"
                            widthMode: "narrow"
                            shape: "round"
                            tooltip: "Confirm (XL Narrow)"
                        }
                        Text {
                            text: "128w × 136h"
                            font.pixelSize: 11
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Text {
                            text: "Default"
                            font.pixelSize: 12
                            font.weight: Font.Medium
                            color: Su.ChiTheme.colors.onBackground
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        Su.IconButton {
                            icon: "✓"
                            variant: "tonal"
                            size: "xlarge"
                            widthMode: "default"
                            shape: "round"
                            tooltip: "Confirm (XL Default)"
                        }
                        Text {
                            text: "136w × 136h"
                            font.pixelSize: 11
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Text {
                            text: "Wide"
                            font.pixelSize: 12
                            font.weight: Font.Medium
                            color: Su.ChiTheme.colors.onBackground
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        Su.IconButton {
                            icon: "✓"
                            variant: "tonal"
                            size: "xlarge"
                            widthMode: "wide"
                            shape: "round"
                            tooltip: "Confirm (XL Wide)"
                        }
                        Text {
                            text: "148w × 136h"
                            font.pixelSize: 11
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: Su.ChiTheme.colors.outline
                opacity: 0.3
            }

            // STATES
            Column {
                width: parent.width
                spacing: 20

                Text {
                    text: "Button States"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Grid {
                    columns: 5
                    columnSpacing: 30
                    rowSpacing: 20

                    Column {
                        spacing: 8
                        Su.IconButton {
                            icon: "✓"
                            variant: "filled"
                            tooltip: "Enabled"
                        }
                        Text {
                            text: "Enabled"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.IconButton {
                            icon: "✓"
                            variant: "filled"
                            tooltip: "Hover me"
                        }
                        Text {
                            text: "Hovered"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.IconButton {
                            icon: "✓"
                            variant: "filled"
                            focus: true
                            tooltip: "Focused (3px border)"
                        }
                        Text {
                            text: "Focused"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.IconButton {
                            icon: "✓"
                            variant: "filled"
                            tooltip: "Press me (morphs to square)"
                        }
                        Text {
                            text: "Pressed"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.IconButton {
                            icon: "✓"
                            variant: "filled"
                            enabled: false
                        }
                        Text {
                            text: "Disabled"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: Su.ChiTheme.colors.outline
                opacity: 0.3
            }

            // VARIANTS
            Column {
                width: parent.width
                spacing: 20

                Text {
                    text: "Button Variants"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Grid {
                    columns: 4
                    columnSpacing: 30
                    rowSpacing: 20

                    Column {
                        spacing: 8
                        Su.IconButton {
                            icon: "+"
                            variant: "filled"
                            tooltip: "Add (Filled)"
                        }
                        Text {
                            text: "Filled"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.IconButton {
                            icon: "-"
                            variant: "tonal"
                            tooltip: "Remove (Tonal)"
                        }
                        Text {
                            text: "Tonal"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.IconButton {
                            icon: "←"
                            variant: "outlined"
                            tooltip: "Back (Outlined)"
                        }
                        Text {
                            text: "Outlined"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.IconButton {
                            icon: "⋮"
                            variant: "standard"
                            tooltip: "More (Standard)"
                        }
                        Text {
                            text: "Standard"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: Su.ChiTheme.colors.outline
                opacity: 0.3
            }

            // SIZES
            Column {
                width: parent.width
                spacing: 20

                Text {
                    text: "Button Sizes (All Default Width)"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Flow {
                    width: parent.width
                    spacing: 30

                    Column {
                        spacing: 8
                        Su.IconButton {
                            icon: "★"
                            variant: "filled"
                            size: "xsmall"
                            tooltip: "XSmall - 32px"
                        }
                        Text {
                            text: "XSmall 32px"
                            font.pixelSize: 11
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.IconButton {
                            icon: "★"
                            variant: "filled"
                            size: "small"
                            tooltip: "Small - 40px"
                        }
                        Text {
                            text: "Small 40px"
                            font.pixelSize: 11
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.IconButton {
                            icon: "★"
                            variant: "filled"
                            size: "medium"
                            tooltip: "Medium - 56px"
                        }
                        Text {
                            text: "Medium 56px"
                            font.pixelSize: 11
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.IconButton {
                            icon: "★"
                            variant: "filled"
                            size: "large"
                            tooltip: "Large - 96px"
                        }
                        Text {
                            text: "Large 96px"
                            font.pixelSize: 11
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.IconButton {
                            icon: "★"
                            variant: "filled"
                            size: "xlarge"
                            tooltip: "XLarge - 136px"
                        }
                        Text {
                            text: "XLarge 136px"
                            font.pixelSize: 11
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: Su.ChiTheme.colors.outline
                opacity: 0.3
            }

            // SHAPES
            Column {
                width: parent.width
                spacing: 20

                Text {
                    text: "Shapes (Round vs Square)"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Row {
                    spacing: 40

                    Column {
                        spacing: 8
                        Su.IconButton {
                            icon: "○"
                            variant: "filled"
                            shape: "round"
                            tooltip: "Round (radius: 100)"
                        }
                        Text {
                            text: "Round"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.IconButton {
                            icon: "□"
                            variant: "filled"
                            shape: "square"
                            tooltip: "Square (radius: 8)"
                        }
                        Text {
                            text: "Square"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.IconButton {
                            icon: "↑"
                            variant: "tonal"
                            shape: "round"
                            size: "medium"
                            tooltip: "Round Medium"
                        }
                        Text {
                            text: "Round Med"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Column {
                        spacing: 8
                        Su.IconButton {
                            icon: "↓"
                            variant: "tonal"
                            shape: "square"
                            size: "medium"
                            tooltip: "Square Medium"
                        }
                        Text {
                            text: "Square Med"
                            font.pixelSize: 12
                            color: Su.ChiTheme.colors.onSurfaceVariant
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: Su.ChiTheme.colors.outline
                opacity: 0.3
            }

            // PRACTICAL EXAMPLES
            Column {
                width: parent.width
                spacing: 20

                Text {
                    text: "Practical UI Examples"
                    font.family: "Roboto"
                    font.pixelSize: 24
                    font.weight: Font.Medium
                    color: Su.ChiTheme.colors.onBackground
                    Behavior on color { ColorAnimation { duration: 200 } }
                }

                Flow {
                    width: parent.width
                    spacing: 15

                    Su.IconButton {
                        icon: "☰"
                        variant: "standard"
                        tooltip: "Menu"
                        onClicked: console.log("Menu")
                    }

                    Su.IconButton {
                        icon: "←"
                        variant: "outlined"
                        tooltip: "Back"
                        onClicked: console.log("Back")
                    }

                    Su.IconButton {
                        icon: "+"
                        variant: "tonal"
                        tooltip: "Add"
                        onClicked: console.log("Add")
                    }

                    Su.IconButton {
                        icon: "✓"
                        variant: "filled"
                        tooltip: "Confirm"
                        onClicked: console.log("Confirm")
                    }

                    Su.IconButton {
                        icon: "✕"
                        variant: "standard"
                        size: "xsmall"
                        tooltip: "Close"
                        onClicked: console.log("Close")
                    }

                    Su.IconButton {
                        icon: "↑"
                        variant: "filled"
                        size: "medium"
                        tooltip: "Upload"
                        onClicked: console.log("Upload")
                    }

                    Su.IconButton {
                        icon: "☰"
                        variant: "standard"
                        widthMode: "wide"
                        tooltip: "Open Navigation"
                        onClicked: console.log("Navigation")
                    }

                    Su.IconButton {
                        icon: "⋮"
                        variant: "standard"
                        widthMode: "narrow"
                        tooltip: "More Options"
                        onClicked: console.log("More")
                    }

                    Su.IconButton {
                        icon: "★"
                        variant: "tonal"
                        size: "large"
                        tooltip: "Favorite"
                        onClicked: console.log("Favorite")
                    }
                }
            }
        }
    }
}

///////////////////////////////////////////////////////first version

// // library/ui/Buttons/IconButtonShowcase.qml - UPDATE width to widthMode
// import QtQuick
// import QtQuick.Controls.Basic
// import smartui 1.0 as Su

// Rectangle {
//     width: 1200
//     height: 800
//     color: Su.ChiTheme.colors.background
//     radius: 26

//     Behavior on color {
//         ColorAnimation { duration: 200 }
//     }

//     Flickable {
//         anchors.fill: parent
//         anchors.margins: 2
//         contentHeight: mainColumn.height + 80
//         clip: true

//         Column {
//             id: mainColumn
//             anchors.horizontalCenter: parent.horizontalCenter
//             width: parent.width - 80
//             spacing: 40
//             topPadding: 40
//             bottomPadding: 40

//             Row {
//                 width: parent.width
//                 spacing: 20

//                 Text {
//                     text: "Icon Buttons"
//                     font.family: "Roboto"
//                     font.pixelSize: 32
//                     font.weight: Font.Medium
//                     color: Su.ChiTheme.colors.onBackground
//                     anchors.verticalCenter: parent.verticalCenter

//                     Behavior on color {
//                         ColorAnimation { duration: 200 }
//                     }
//                 }

//                 Item { width: 100; height: 1 }

//                 Row {
//                     spacing: 10
//                     anchors.verticalCenter: parent.verticalCenter

//                     Text {
//                         text: "☀️"
//                         font.pixelSize: 20
//                         anchors.verticalCenter: parent.verticalCenter
//                     }

//                     Switch {
//                         checked: Su.ChiTheme.isDarkMode
//                         onToggled: Su.ChiTheme.isDarkMode = !Su.ChiTheme.isDarkMode
//                         anchors.verticalCenter: parent.verticalCenter
//                     }

//                     Text {
//                         text: "🌙"
//                         font.pixelSize: 20
//                         anchors.verticalCenter: parent.verticalCenter
//                     }
//                 }
//             }

//             Text {
//                 text: "Icon-only buttons for actions like menu, search, settings. Hover for tooltips."
//                 font.pixelSize: 14
//                 color: Su.ChiTheme.colors.onSurfaceVariant
//                 Behavior on color { ColorAnimation { duration: 200 } }
//             }

//             Rectangle {
//                 width: parent.width
//                 height: 1
//                 color: Su.ChiTheme.colors.outline
//                 opacity: 0.3
//             }

//             Column {
//                 width: parent.width
//                 spacing: 20

//                 Text {
//                     text: "Width Variations (Small Size)"
//                     font.family: "Roboto"
//                     font.pixelSize: 24
//                     font.weight: Font.Medium
//                     color: Su.ChiTheme.colors.onBackground
//                     Behavior on color { ColorAnimation { duration: 200 } }
//                 }

//                 Row {
//                     spacing: 30

//                     Column {
//                         spacing: 8
//                         Su.IconButton {
//                             icon: "⚙"
//                             variant: "filled"
//                             size: "small"
//                             widthMode: "narrow"
//                             tooltip: "Settings (Narrow)"
//                             onClicked: console.log("Narrow clicked")
//                         }
//                         Text {
//                             text: "Narrow (32x40)"
//                             font.pixelSize: 12
//                             color: Su.ChiTheme.colors.onSurfaceVariant
//                             anchors.horizontalCenter: parent.horizontalCenter
//                         }
//                     }

//                     Column {
//                         spacing: 8
//                         Su.IconButton {
//                             icon: "🔍"
//                             variant: "filled"
//                             size: "small"
//                             widthMode: "default"
//                             tooltip: "Search (Default)"
//                             onClicked: console.log("Default clicked")
//                         }
//                         Text {
//                             text: "Default (40x40)"
//                             font.pixelSize: 12
//                             color: Su.ChiTheme.colors.onSurfaceVariant
//                             anchors.horizontalCenter: parent.horizontalCenter
//                         }
//                     }

//                     Column {
//                         spacing: 8
//                         Su.IconButton {
//                             icon: "☰"
//                             variant: "filled"
//                             size: "small"
//                             widthMode: "wide"
//                             tooltip: "Menu (Wide)"
//                             onClicked: console.log("Wide clicked")
//                         }
//                         Text {
//                             text: "Wide (52x40)"
//                             font.pixelSize: 12
//                             color: Su.ChiTheme.colors.onSurfaceVariant
//                             anchors.horizontalCenter: parent.horizontalCenter
//                         }
//                     }
//                 }
//             }

//             Rectangle {
//                 width: parent.width
//                 height: 1
//                 color: Su.ChiTheme.colors.outline
//                 opacity: 0.3
//             }

//             Column {
//                 width: parent.width
//                 spacing: 20

//                 Text {
//                     text: "Button States (Default Width)"
//                     font.family: "Roboto"
//                     font.pixelSize: 24
//                     font.weight: Font.Medium
//                     color: Su.ChiTheme.colors.onBackground
//                     Behavior on color { ColorAnimation { duration: 200 } }
//                 }

//                 Grid {
//                     columns: 5
//                     columnSpacing: 30
//                     rowSpacing: 20

//                     Column {
//                         spacing: 8
//                         Su.IconButton {
//                             icon: "✓"
//                             variant: "filled"
//                             tooltip: "Enabled"
//                         }
//                         Text {
//                             text: "Enabled"
//                             font.pixelSize: 12
//                             color: Su.ChiTheme.colors.onSurfaceVariant
//                             anchors.horizontalCenter: parent.horizontalCenter
//                         }
//                     }

//                     Column {
//                         spacing: 8
//                         Su.IconButton {
//                             icon: "✓"
//                             variant: "filled"
//                             tooltip: "Hover over me"
//                         }
//                         Text {
//                             text: "Hovered"
//                             font.pixelSize: 12
//                             color: Su.ChiTheme.colors.onSurfaceVariant
//                             anchors.horizontalCenter: parent.horizontalCenter
//                         }
//                     }

//                     Column {
//                         spacing: 8
//                         Su.IconButton {
//                             icon: "✓"
//                             variant: "filled"
//                             focus: true
//                             tooltip: "Focused"
//                         }
//                         Text {
//                             text: "Focused (border)"
//                             font.pixelSize: 12
//                             color: Su.ChiTheme.colors.onSurfaceVariant
//                             anchors.horizontalCenter: parent.horizontalCenter
//                         }
//                     }

//                     Column {
//                         spacing: 8
//                         Su.IconButton {
//                             icon: "✓"
//                             variant: "filled"
//                             tooltip: "Press me"
//                         }
//                         Text {
//                             text: "Pressed"
//                             font.pixelSize: 12
//                             color: Su.ChiTheme.colors.onSurfaceVariant
//                             anchors.horizontalCenter: parent.horizontalCenter
//                         }
//                     }

//                     Column {
//                         spacing: 8
//                         Su.IconButton {
//                             icon: "✓"
//                             variant: "filled"
//                             enabled: false
//                         }
//                         Text {
//                             text: "Disabled"
//                             font.pixelSize: 12
//                             color: Su.ChiTheme.colors.onSurfaceVariant
//                             anchors.horizontalCenter: parent.horizontalCenter
//                         }
//                     }
//                 }
//             }

//             Rectangle {
//                 width: parent.width
//                 height: 1
//                 color: Su.ChiTheme.colors.outline
//                 opacity: 0.3
//             }

//             Column {
//                 width: parent.width
//                 spacing: 20

//                 Text {
//                     text: "Button Variants"
//                     font.family: "Roboto"
//                     font.pixelSize: 24
//                     font.weight: Font.Medium
//                     color: Su.ChiTheme.colors.onBackground
//                     Behavior on color { ColorAnimation { duration: 200 } }
//                 }

//                 Grid {
//                     columns: 4
//                     columnSpacing: 30
//                     rowSpacing: 20

//                     Column {
//                         spacing: 8
//                         Su.IconButton {
//                             icon: "❤"
//                             variant: "filled"
//                             tooltip: "Favorite (Filled)"
//                         }
//                         Text {
//                             text: "Filled"
//                             font.pixelSize: 12
//                             color: Su.ChiTheme.colors.onSurfaceVariant
//                             anchors.horizontalCenter: parent.horizontalCenter
//                         }
//                     }

//                     Column {
//                         spacing: 8
//                         Su.IconButton {
//                             icon: "🔔"
//                             variant: "tonal"
//                             tooltip: "Notifications (Tonal)"
//                         }
//                         Text {
//                             text: "Tonal"
//                             font.pixelSize: 12
//                             color: Su.ChiTheme.colors.onSurfaceVariant
//                             anchors.horizontalCenter: parent.horizontalCenter
//                         }
//                     }

//                     Column {
//                         spacing: 8
//                         Su.IconButton {
//                             icon: "⊕"
//                             variant: "outlined"
//                             tooltip: "Add (Outlined)"
//                         }
//                         Text {
//                             text: "Outlined"
//                             font.pixelSize: 12
//                             color: Su.ChiTheme.colors.onSurfaceVariant
//                             anchors.horizontalCenter: parent.horizontalCenter
//                         }
//                     }

//                     Column {
//                         spacing: 8
//                         Su.IconButton {
//                             icon: "⋮"
//                             variant: "standard"
//                             tooltip: "More (Standard)"
//                         }
//                         Text {
//                             text: "Standard"
//                             font.pixelSize: 12
//                             color: Su.ChiTheme.colors.onSurfaceVariant
//                             anchors.horizontalCenter: parent.horizontalCenter
//                         }
//                     }
//                 }
//             }

//             Rectangle {
//                 width: parent.width
//                 height: 1
//                 color: Su.ChiTheme.colors.outline
//                 opacity: 0.3
//             }

//             Column {
//                 width: parent.width
//                 spacing: 20

//                 Text {
//                     text: "Button Sizes"
//                     font.family: "Roboto"
//                     font.pixelSize: 24
//                     font.weight: Font.Medium
//                     color: Su.ChiTheme.colors.onBackground
//                     Behavior on color { ColorAnimation { duration: 200 } }
//                 }

//                 Flow {
//                     width: parent.width
//                     spacing: 20

//                     Column {
//                         spacing: 8
//                         Su.IconButton {
//                             icon: "★"
//                             variant: "filled"
//                             size: "xsmall"
//                             tooltip: "XSmall (32px)"
//                         }
//                         Text {
//                             text: "XSmall"
//                             font.pixelSize: 11
//                             color: Su.ChiTheme.colors.onSurfaceVariant
//                             anchors.horizontalCenter: parent.horizontalCenter
//                         }
//                     }

//                     Column {
//                         spacing: 8
//                         Su.IconButton {
//                             icon: "★"
//                             variant: "filled"
//                             size: "small"
//                             tooltip: "Small (40px)"
//                         }
//                         Text {
//                             text: "Small"
//                             font.pixelSize: 11
//                             color: Su.ChiTheme.colors.onSurfaceVariant
//                             anchors.horizontalCenter: parent.horizontalCenter
//                         }
//                     }

//                     Column {
//                         spacing: 8
//                         Su.IconButton {
//                             icon: "★"
//                             variant: "filled"
//                             size: "medium"
//                             tooltip: "Medium (56px)"
//                         }
//                         Text {
//                             text: "Medium"
//                             font.pixelSize: 11
//                             color: Su.ChiTheme.colors.onSurfaceVariant
//                             anchors.horizontalCenter: parent.horizontalCenter
//                         }
//                     }

//                     Column {
//                         spacing: 8
//                         Su.IconButton {
//                             icon: "★"
//                             variant: "filled"
//                             size: "large"
//                             tooltip: "Large (96px)"
//                         }
//                         Text {
//                             text: "Large"
//                             font.pixelSize: 11
//                             color: Su.ChiTheme.colors.onSurfaceVariant
//                             anchors.horizontalCenter: parent.horizontalCenter
//                         }
//                     }

//                     Column {
//                         spacing: 8
//                         Su.IconButton {
//                             icon: "★"
//                             variant: "filled"
//                             size: "xlarge"
//                             tooltip: "XLarge (136px)"
//                         }
//                         Text {
//                             text: "XLarge"
//                             font.pixelSize: 11
//                             color: Su.ChiTheme.colors.onSurfaceVariant
//                             anchors.horizontalCenter: parent.horizontalCenter
//                         }
//                     }
//                 }
//             }

//             Rectangle {
//                 width: parent.width
//                 height: 1
//                 color: Su.ChiTheme.colors.outline
//                 opacity: 0.3
//             }

//             Column {
//                 width: parent.width
//                 spacing: 20

//                 Text {
//                     text: "Button Shapes"
//                     font.family: "Roboto"
//                     font.pixelSize: 24
//                     font.weight: Font.Medium
//                     color: Su.ChiTheme.colors.onBackground
//                     Behavior on color { ColorAnimation { duration: 200 } }
//                 }

//                 Row {
//                     spacing: 30

//                     Column {
//                         spacing: 8
//                         Su.IconButton {
//                             icon: "○"
//                             variant: "filled"
//                             shape: "round"
//                             tooltip: "Round Shape"
//                         }
//                         Text {
//                             text: "Round"
//                             font.pixelSize: 12
//                             color: Su.ChiTheme.colors.onSurfaceVariant
//                             anchors.horizontalCenter: parent.horizontalCenter
//                         }
//                     }

//                     Column {
//                         spacing: 8
//                         Su.IconButton {
//                             icon: "□"
//                             variant: "filled"
//                             shape: "square"
//                             tooltip: "Square Shape"
//                         }
//                         Text {
//                             text: "Square"
//                             font.pixelSize: 12
//                             color: Su.ChiTheme.colors.onSurfaceVariant
//                             anchors.horizontalCenter: parent.horizontalCenter
//                         }
//                     }
//                 }
//             }

//             Rectangle {
//                 width: parent.width
//                 height: 1
//                 color: Su.ChiTheme.colors.outline
//                 opacity: 0.3
//             }

//             Column {
//                 width: parent.width
//                 spacing: 20

//                 Text {
//                     text: "Practical Examples"
//                     font.family: "Roboto"
//                     font.pixelSize: 24
//                     font.weight: Font.Medium
//                     color: Su.ChiTheme.colors.onBackground
//                     Behavior on color { ColorAnimation { duration: 200 } }
//                 }

//                 Flow {
//                     width: parent.width
//                     spacing: 15

//                     Su.IconButton {
//                         icon: "⚙"
//                         variant: "standard"
//                         tooltip: "Settings"
//                         onClicked: console.log("Settings")
//                     }

//                     Su.IconButton {
//                         icon: "🔍"
//                         variant: "outlined"
//                         tooltip: "Search"
//                         onClicked: console.log("Search")
//                     }

//                     Su.IconButton {
//                         icon: "🔔"
//                         variant: "tonal"
//                         tooltip: "Notifications"
//                         onClicked: console.log("Notifications")
//                     }

//                     Su.IconButton {
//                         icon: "❤"
//                         variant: "filled"
//                         tooltip: "Favorite"
//                         onClicked: console.log("Favorite")
//                     }

//                     Su.IconButton {
//                         icon: "⊕"
//                         variant: "filled"
//                         size: "medium"
//                         tooltip: "Add Item"
//                         onClicked: console.log("Add")
//                     }

//                     Su.IconButton {
//                         icon: "☰"
//                         variant: "standard"
//                         widthMode: "wide"
//                         tooltip: "Open Menu"
//                         onClicked: console.log("Menu")
//                     }

//                     Su.IconButton {
//                         icon: "×"
//                         variant: "standard"
//                         size: "xsmall"
//                         tooltip: "Close"
//                         onClicked: console.log("Close")
//                     }
//                 }
//             }
//         }
//     }
// }
