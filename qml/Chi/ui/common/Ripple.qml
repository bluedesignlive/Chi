// Ripple.qml - True Material 3 Expanding Wave (With Hang Time Physics)
import QtQuick
import QtQuick.Effects
import "../../theme" as Theme

Item {
    id: root
    anchors.fill: parent

    property color color: "white"
    property real radius: 0 
    property bool enabled: true

    readonly property real _maxSize: Math.sqrt(width * width + height * height) * 2.2

    Rectangle {
        id: maskRect
        anchors.fill: parent
        radius: root.radius
        color: "black"
        layer.enabled: true
        visible: false
    }

    Item {
        anchors.fill: parent
        layer.enabled: true
        layer.effect: MultiEffect {
            maskEnabled: true
            maskSource: maskRect
        }

        Rectangle {
            id: wave
            color: root.color
            radius: width / 2
            opacity: 0

            property real startX: root.width / 2
            property real startY: root.height / 2

            x: startX - width / 2
            y: startY - height / 2
            height: width
        }
    }

    NumberAnimation {
        id: growAnim
        target: wave
        property: "width"
        from: 0
        to: root._maxSize
        duration: 600              // Your 600ms sweet spot
        easing.type: Easing.OutSine
    }

    // Wrap the fade in a sequence so we can inject a pause
    SequentialAnimation {
        id: fadeAnim
        
        // THE HANG TIME: Wait 150ms before fading so the wave can finish traveling!
        PauseAnimation { duration: 150 } 
        
        NumberAnimation {
            target: wave
            property: "opacity"
            to: 0
            duration: 400
            easing.type: Easing.InOutQuad
        }
    }

    function addRipple(mx, my) {
        if (!enabled) return;
        
        fadeAnim.stop();
        growAnim.stop();
        
        wave.startX = mx !== undefined ? mx : root.width / 2;
        wave.startY = my !== undefined ? my : root.height / 2;
        
        wave.width = 0;
        wave.opacity = 0.24; 
        
        growAnim.restart();
    }

    function removeRipple() {
        fadeAnim.restart();
    }
}
