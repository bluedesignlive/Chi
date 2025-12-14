import QtQuick
import QtQuick.Effects
import "../../theme"

Item {
    id: root

    property int itemIndex: 0
    property var itemData: ({})
    property string itemSize: "large"
    property real parallaxOffset: 0
    property int radius: 28

    property string imageSource: {
        if (!itemData) return ""
        return String(itemData.source || itemData.image || itemData.imageUrl || "")
    }
    property string title: itemData ? String(itemData.title || "") : ""
    property string subtitle: itemData ? String(itemData.subtitle || itemData.description || "") : ""
    property string label: itemData ? String(itemData.label || "") : ""

    signal clicked()
    signal pressAndHold()

    // Computed visibility for text animation
    property real textVisibility: {
        if (itemSize === "large") return 1.0
        if (itemSize === "medium") return 0.5
        return 0.0
    }

    Rectangle {
        id: mask
        anchors.fill: parent
        radius: root.radius
        visible: false
        layer.enabled: true
    }

    Item {
        id: content
        anchors.fill: parent
        
        layer.enabled: true
        layer.samples: 4
        layer.effect: MultiEffect {
            maskEnabled: true
            maskSource: mask
            maskThresholdMin: 0.5
            maskSpreadAtMin: 1.0
        }

        Rectangle {
            id: bg
            anchors.fill: parent
            color: ChiTheme.colors.surfaceContainerLow
        }

        Image {
            id: img
            
            x: -25 + (root.parallaxOffset * root.width * 0.15)
            y: -15
            width: parent.width + 50
            height: parent.height + 30
            
            source: root.imageSource
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            cache: true

            Behavior on x {
                NumberAnimation { duration: 80; easing.type: Easing.OutQuad }
            }
        }

        Rectangle {
            anchors.fill: parent
            color: ChiTheme.colors.surfaceContainerLow
            visible: img.status === Image.Loading

            Rectangle {
                anchors.centerIn: parent
                width: 36
                height: 36
                radius: 18
                color: "transparent"
                border.width: 3
                border.color: ChiTheme.colors.primary

                RotationAnimation on rotation {
                    from: 0
                    to: 360
                    duration: 1000
                    loops: Animation.Infinite
                    running: img.status === Image.Loading
                }
            }
        }

        Rectangle {
            anchors.fill: parent
            color: ChiTheme.colors.surfaceContainerLow
            visible: img.status === Image.Error && root.imageSource !== ""

            Column {
                anchors.centerIn: parent
                spacing: 8
                opacity: 0.5

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "✕"
                    font.pixelSize: 28
                    color: ChiTheme.colors.onSurfaceVariant
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("No image")
                    font.pixelSize: 12
                    color: ChiTheme.colors.onSurfaceVariant
                }
            }
        }

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: parent.height * 0.55
            visible: root.textVisibility > 0 && (root.title.length > 0 || root.subtitle.length > 0)
            opacity: root.textVisibility

            gradient: Gradient {
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 0.45; color: Qt.rgba(0, 0, 0, 0.2) }
                GradientStop { position: 1.0; color: Qt.rgba(0, 0, 0, 0.7) }
            }
            
            Behavior on opacity {
                NumberAnimation { duration: 250; easing.type: Easing.OutQuad }
            }
        }

        // Text container with path-based animation
        Item {
            id: textContainer
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 14
            height: textColumn.height
            
            opacity: root.textVisibility
            visible: opacity > 0.01
            
            // Slide up from bottom as it reveals
            transform: Translate {
                y: (1 - root.textVisibility) * 20
            }
            
            Behavior on opacity {
                NumberAnimation { 
                    duration: 280
                    easing.type: Easing.OutCubic
                }
            }

            Column {
                id: textColumn
                width: parent.width
                spacing: 3

                // Label
                Text {
                    id: labelText
                    width: parent.width
                    text: root.label.toUpperCase()
                    color: Qt.rgba(1, 1, 1, 0.85)
                    font.pixelSize: 10
                    font.weight: Font.Bold
                    font.letterSpacing: 1.2
                    elide: Text.ElideRight
                    
                    opacity: root.itemSize === "large" && root.label.length > 0 ? 1 : 0
                    height: opacity > 0 ? implicitHeight : 0
                    visible: height > 0
                    
                    transform: Translate {
                        y: (1 - labelText.opacity) * 8
                    }
                    
                    Behavior on opacity {
                        NumberAnimation { 
                            duration: 220
                            easing.type: Easing.OutCubic
                        }
                    }
                }

                // Title
                Text {
                    id: titleText
                    width: parent.width
                    text: root.title
                    color: "#FFFFFF"
                    font.pixelSize: root.itemSize === "large" ? 18 : 13
                    font.weight: Font.DemiBold
                    lineHeight: 1.15
                    elide: Text.ElideRight
                    maximumLineCount: root.itemSize === "large" ? 2 : 1
                    wrapMode: Text.Wrap
                    visible: root.title.length > 0
                    
                    transform: Translate {
                        y: (1 - root.textVisibility) * 6
                    }

                    Behavior on font.pixelSize { 
                        NumberAnimation { duration: 200; easing.type: Easing.OutCubic } 
                    }
                }

                // Subtitle
                Text {
                    id: subtitleText
                    width: parent.width
                    text: root.subtitle
                    color: Qt.rgba(1, 1, 1, 0.75)
                    font.pixelSize: 12
                    elide: Text.ElideRight
                    maximumLineCount: 1
                    
                    opacity: root.itemSize === "large" && root.subtitle.length > 0 ? 1 : 0
                    height: opacity > 0 ? implicitHeight : 0
                    visible: height > 0
                    
                    transform: Translate {
                        y: (1 - subtitleText.opacity) * 6
                    }
                    
                    Behavior on opacity {
                        NumberAnimation { 
                            duration: 200
                            easing.type: Easing.OutCubic
                        }
                    }
                }
            }
        }

        Rectangle {
            anchors.fill: parent
            color: ChiTheme.colors.onSurface
            opacity: mouseArea.containsMouse && !mouseArea.pressed ? 0.08 : 0
            
            Behavior on opacity { 
                NumberAnimation { duration: 100 } 
            }
        }

        Rectangle {
            id: ripple
            
            property real centerX: mouseArea.pressX
            property real centerY: mouseArea.pressY
            
            x: centerX - width / 2
            y: centerY - height / 2
            width: mouseArea.pressed ? Math.max(parent.width, parent.height) * 2.5 : 0
            height: width
            radius: width / 2
            color: ChiTheme.colors.onSurface
            opacity: mouseArea.pressed ? 0.1 : 0

            Behavior on width {
                NumberAnimation { duration: 400; easing.type: Easing.OutCubic }
            }
            Behavior on opacity {
                NumberAnimation { duration: mouseArea.pressed ? 50 : 250 }
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        
        property real pressX: 0
        property real pressY: 0
        property real startX: 0
        property bool moved: false

        onPressed: function(mouse) {
            pressX = mouse.x
            pressY = mouse.y
            startX = mouse.x
            moved = false
        }

        onPositionChanged: function(mouse) {
            if (Math.abs(mouse.x - startX) > 15) {
                moved = true
            }
        }

        onReleased: {
            if (!moved) {
                root.clicked()
            }
        }

        onPressAndHold: {
            if (!moved) {
                root.pressAndHold()
            }
        }
    }

    Accessible.role: Accessible.Button
    Accessible.name: root.title.length > 0 ? root.title : qsTr("Carousel item %1").arg(itemIndex + 1)
}
