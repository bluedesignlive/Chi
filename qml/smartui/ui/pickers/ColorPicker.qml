import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import "../../theme" as Theme

Item {
    id: root

    property color selectedColor: "#ff0000"
    property color initialColor: "#ff0000"
    property bool showAlpha: true
    property bool showInputs: true
    property bool showPresets: true
    property bool showEyedropper: true
    property string format: "hex"            // "hex", "rgb", "hsl"
    property var presetColors: [
        "#f44336", "#e91e63", "#9c27b0", "#673ab7",
        "#3f51b5", "#2196f3", "#03a9f4", "#00bcd4",
        "#009688", "#4caf50", "#8bc34a", "#cddc39",
        "#ffeb3b", "#ffc107", "#ff9800", "#ff5722",
        "#795548", "#9e9e9e", "#607d8b", "#000000",
        "#ffffff"
    ]

    signal colorSelected(color color)
    signal cancelled()

    // Color conversion utilities
    readonly property real hue: internal.hue
    readonly property real saturation: internal.saturation
    readonly property real lightness: internal.lightness
    readonly property real alpha: internal.alpha

    implicitWidth: 320
    implicitHeight: showPresets ? 480 : 420

    property var colors: Theme.ChiTheme.colors

    QtObject {
        id: internal

        property real hue: 0
        property real saturation: 1
        property real lightness: 0.5
        property real alpha: 1

        function colorToHsl(c) {
            var r = c.r, g = c.g, b = c.b
            var max = Math.max(r, g, b), min = Math.min(r, g, b)
            var h, s, l = (max + min) / 2

            if (max === min) {
                h = s = 0
            } else {
                var d = max - min
                s = l > 0.5 ? d / (2 - max - min) : d / (max + min)
                switch (max) {
                    case r: h = ((g - b) / d + (g < b ? 6 : 0)) / 6; break
                    case g: h = ((b - r) / d + 2) / 6; break
                    case b: h = ((r - g) / d + 4) / 6; break
                }
            }

            return { h: h, s: s, l: l }
        }

        function hslToColor(h, s, l, a) {
            var r, g, b

            if (s === 0) {
                r = g = b = l
            } else {
                function hue2rgb(p, q, t) {
                    if (t < 0) t += 1
                    if (t > 1) t -= 1
                    if (t < 1/6) return p + (q - p) * 6 * t
                    if (t < 1/2) return q
                    if (t < 2/3) return p + (q - p) * (2/3 - t) * 6
                    return p
                }

                var q = l < 0.5 ? l * (1 + s) : l + s - l * s
                var p = 2 * l - q
                r = hue2rgb(p, q, h + 1/3)
                g = hue2rgb(p, q, h)
                b = hue2rgb(p, q, h - 1/3)
            }

            return Qt.rgba(r, g, b, a)
        }

        function updateFromColor(c) {
            var hsl = colorToHsl(c)
            hue = hsl.h
            saturation = hsl.s
            lightness = hsl.l
            alpha = c.a
        }

        function updateSelectedColor() {
            selectedColor = hslToColor(hue, saturation, lightness, alpha)
        }

        Component.onCompleted: {
            updateFromColor(initialColor)
        }
    }

    Rectangle {
        anchors.fill: parent
        radius: 28
        color: colors.surfaceContainerHigh
        clip: true

        Behavior on color {
            ColorAnimation { duration: 200 }
        }

        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: 8
            radius: 24
            samples: 25
            color: Qt.rgba(0, 0, 0, 0.2)
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 16

            // Header
            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                Text {
                    text: "Color Picker"
                    font.family: "Roboto"
                    font.pixelSize: 18
                    font.weight: Font.Medium
                    color: colors.onSurface
                    Layout.fillWidth: true

                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }
                }

                // Eyedropper button
                Item {
                    visible: showEyedropper
                    Layout.preferredWidth: 40
                    Layout.preferredHeight: 40

                    Rectangle {
                        anchors.fill: parent
                        radius: 20
                        color: colors.onSurface
                        opacity: eyedropperMouse.containsMouse ? 0.08 : 0
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "💉"
                        font.pixelSize: 18
                    }

                    MouseArea {
                        id: eyedropperMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            // Eyedropper functionality would need platform integration
                            console.log("Eyedropper clicked - requires platform integration")
                        }
                    }
                }
            }

            // Color preview comparison
            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 48
                spacing: 0

                // New color
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 8

                    // Checkerboard for transparency
                    Canvas {
                        anchors.fill: parent
                        onPaint: {
                            var ctx = getContext("2d")
                            var size = 8
                            for (var x = 0; x < width; x += size) {
                                for (var y = 0; y < height; y += size) {
                                    ctx.fillStyle = ((x / size + y / size) % 2 === 0) ? "#ffffff" : "#cccccc"
                                    ctx.fillRect(x, y, size, size)
                                }
                            }
                        }

                        layer.enabled: true
                        layer.effect: OpacityMask {
                            maskSource: Rectangle {
                                width: parent.width
                                height: parent.height
                                radius: 8

                                Rectangle {
                                    anchors.right: parent.right
                                    width: parent.width / 2
                                    height: parent.height
                                }
                            }
                        }
                    }

                    Rectangle {
                        anchors.fill: parent
                        radius: 8
                        color: selectedColor

                        Text {
                            anchors.centerIn: parent
                            text: "New"
                            font.family: "Roboto"
                            font.pixelSize: 11
                            color: selectedColor.hslLightness > 0.5 ? "#000000" : "#ffffff"
                        }
                    }
                }

                // Original color
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 8
                    color: initialColor

                    Rectangle {
                        anchors.left: parent.left
                        width: 8
                        height: parent.height
                        color: parent.color
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "Original"
                        font.family: "Roboto"
                        font.pixelSize: 11
                        color: initialColor.hslLightness > 0.5 ? "#000000" : "#ffffff"
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            internal.updateFromColor(initialColor)
                            internal.updateSelectedColor()
                        }
                    }
                }
            }

            // Saturation/Lightness picker
            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 160

                Rectangle {
                    id: slPicker
                    anchors.fill: parent
                    radius: 8

                    // Hue base
                    Rectangle {
                        anchors.fill: parent
                        radius: parent.radius
                        color: Qt.hsla(internal.hue, 1, 0.5, 1)
                    }

                    // White gradient (left to right)
                    Rectangle {
                        anchors.fill: parent
                        radius: parent.radius
                        gradient: Gradient {
                            orientation: Gradient.Horizontal
                            GradientStop { position: 0.0; color: "#ffffff" }
                            GradientStop { position: 1.0; color: "transparent" }
                        }
                    }

                    // Black gradient (bottom to top)
                    Rectangle {
                        anchors.fill: parent
                        radius: parent.radius
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: "transparent" }
                            GradientStop { position: 1.0; color: "#000000" }
                        }
                    }

                    // Picker cursor
                    Rectangle {
                        id: slCursor
                        width: 20
                        height: 20
                        radius: 10
                        border.width: 3
                        border.color: "#ffffff"
                        color: "transparent"

                        x: internal.saturation * (parent.width - width)
                        y: (1 - internal.lightness) * (parent.height - height)

                        layer.enabled: true
                        layer.effect: DropShadow {
                            transparentBorder: true
                            horizontalOffset: 0
                            verticalOffset: 1
                            radius: 3
                            samples: 7
                            color: Qt.rgba(0, 0, 0, 0.4)
                        }

                        Rectangle {
                            anchors.fill: parent
                            anchors.margins: 4
                            radius: width / 2
                            color: selectedColor
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        preventStealing: true

                        function updateSL(mouse) {
                            internal.saturation = Math.max(0, Math.min(1, mouse.x / width))
                            internal.lightness = Math.max(0, Math.min(1, 1 - mouse.y / height))
                            internal.updateSelectedColor()
                        }

                        onPressed: (mouse) => updateSL(mouse)
                        onPositionChanged: (mouse) => { if (pressed) updateSL(mouse) }
                    }
                }
            }

            // Hue slider
            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 24

                Rectangle {
                    anchors.fill: parent
                    radius: 12

                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { position: 0.000; color: "#ff0000" }
                        GradientStop { position: 0.167; color: "#ffff00" }
                        GradientStop { position: 0.333; color: "#00ff00" }
                        GradientStop { position: 0.500; color: "#00ffff" }
                        GradientStop { position: 0.667; color: "#0000ff" }
                        GradientStop { position: 0.833; color: "#ff00ff" }
                        GradientStop { position: 1.000; color: "#ff0000" }
                    }
                }

                Rectangle {
                    id: hueCursor
                    width: 24
                    height: 24
                    radius: 12
                    border.width: 3
                    border.color: "#ffffff"
                    color: Qt.hsla(internal.hue, 1, 0.5, 1)

                    x: internal.hue * (parent.width - width)
                    y: 0

                    layer.enabled: true
                    layer.effect: DropShadow {
                        transparentBorder: true
                        horizontalOffset: 0
                        verticalOffset: 1
                        radius: 3
                        samples: 7
                        color: Qt.rgba(0, 0, 0, 0.4)
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    preventStealing: true

                    function updateHue(mouse) {
                        internal.hue = Math.max(0, Math.min(1, mouse.x / width))
                        internal.updateSelectedColor()
                    }

                    onPressed: (mouse) => updateHue(mouse)
                    onPositionChanged: (mouse) => { if (pressed) updateHue(mouse) }
                }
            }

            // Alpha slider
            Item {
                visible: showAlpha
                Layout.fillWidth: true
                Layout.preferredHeight: 24

                // Checkerboard background
                Canvas {
                    anchors.fill: parent
                    onPaint: {
                        var ctx = getContext("2d")
                        var size = 6
                        ctx.clearRect(0, 0, width, height)
                        for (var x = 0; x < width; x += size) {
                            for (var y = 0; y < height; y += size) {
                                ctx.fillStyle = ((x / size + y / size) % 2 === 0) ? "#ffffff" : "#cccccc"
                                ctx.fillRect(x, y, size, size)
                            }
                        }
                    }

                    layer.enabled: true
                    layer.effect: OpacityMask {
                        maskSource: Rectangle {
                            width: parent.width
                            height: parent.height
                            radius: 12
                        }
                    }
                }

                Rectangle {
                    anchors.fill: parent
                    radius: 12

                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { position: 0.0; color: Qt.rgba(selectedColor.r, selectedColor.g, selectedColor.b, 0) }
                        GradientStop { position: 1.0; color: Qt.rgba(selectedColor.r, selectedColor.g, selectedColor.b, 1) }
                    }
                }

                Rectangle {
                    id: alphaCursor
                    width: 24
                    height: 24
                    radius: 12
                    border.width: 3
                    border.color: "#ffffff"
                    color: selectedColor

                    x: internal.alpha * (parent.width - width)
                    y: 0

                    layer.enabled: true
                    layer.effect: DropShadow {
                        transparentBorder: true
                        horizontalOffset: 0
                        verticalOffset: 1
                        radius: 3
                        samples: 7
                        color: Qt.rgba(0, 0, 0, 0.4)
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    preventStealing: true

                    function updateAlpha(mouse) {
                        internal.alpha = Math.max(0, Math.min(1, mouse.x / width))
                        internal.updateSelectedColor()
                    }

                    onPressed: (mouse) => updateAlpha(mouse)
                    onPositionChanged: (mouse) => { if (pressed) updateAlpha(mouse) }
                }
            }

            // Input fields
            RowLayout {
                visible: showInputs
                Layout.fillWidth: true
                spacing: 8

                // Format selector
                Rectangle {
                    Layout.preferredWidth: 60
                    Layout.preferredHeight: 36
                    radius: 4
                    color: colors.surfaceContainerHighest
                    border.width: 1
                    border.color: colors.outline

                    Text {
                        anchors.centerIn: parent
                        text: format.toUpperCase()
                        font.family: "Roboto"
                        font.pixelSize: 12
                        font.weight: Font.Medium
                        color: colors.onSurface
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (format === "hex") format = "rgb"
                            else if (format === "rgb") format = "hsl"
                            else format = "hex"
                        }
                    }
                }

                // HEX input
                Rectangle {
                    visible: format === "hex"
                    Layout.fillWidth: true
                    Layout.preferredHeight: 36
                    radius: 4
                    color: colors.surfaceContainerHighest
                    border.width: 1
                    border.color: hexInput.activeFocus ? colors.primary : colors.outline

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 8
                        anchors.rightMargin: 8
                        spacing: 4

                        Text {
                            text: "#"
                            font.family: "JetBrains Mono, monospace"
                            font.pixelSize: 14
                            color: colors.onSurfaceVariant
                        }

                        TextInput {
                            id: hexInput
                            Layout.fillWidth: true
                            font.family: "JetBrains Mono, monospace"
                            font.pixelSize: 14
                            color: colors.onSurface
                            maximumLength: showAlpha ? 8 : 6
                            validator: RegularExpressionValidator { regularExpression: /[0-9A-Fa-f]*/ }

                            text: {
                                var hex = selectedColor.toString().substring(1)
                                if (!showAlpha && hex.length === 8) {
                                    hex = hex.substring(2)
                                }
                                return hex.toUpperCase()
                            }

                            onEditingFinished: {
                                var hex = text
                                if (hex.length === 6) {
                                    internal.updateFromColor(Qt.rgba(
                                        parseInt(hex.substring(0, 2), 16) / 255,
                                        parseInt(hex.substring(2, 4), 16) / 255,
                                        parseInt(hex.substring(4, 6), 16) / 255,
                                        internal.alpha
                                    ))
                                } else if (hex.length === 8) {
                                    internal.updateFromColor(Qt.rgba(
                                        parseInt(hex.substring(2, 4), 16) / 255,
                                        parseInt(hex.substring(4, 6), 16) / 255,
                                        parseInt(hex.substring(6, 8), 16) / 255,
                                        parseInt(hex.substring(0, 2), 16) / 255
                                    ))
                                }
                                internal.updateSelectedColor()
                            }
                        }
                    }
                }

                // RGB inputs
                RowLayout {
                    visible: format === "rgb"
                    Layout.fillWidth: true
                    spacing: 4

                    Repeater {
                        model: ["R", "G", "B"]

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 36
                            radius: 4
                            color: colors.surfaceContainerHighest
                            border.width: 1
                            border.color: colors.outline

                            Column {
                                anchors.centerIn: parent
                                spacing: 0

                                Text {
                                    text: modelData
                                    font.family: "Roboto"
                                    font.pixelSize: 10
                                    color: colors.onSurfaceVariant
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                TextInput {
                                    width: 30
                                    font.family: "JetBrains Mono, monospace"
                                    font.pixelSize: 12
                                    color: colors.onSurface
                                    horizontalAlignment: Text.AlignHCenter
                                    maximumLength: 3
                                    validator: IntValidator { bottom: 0; top: 255 }

                                    text: {
                                        if (modelData === "R") return Math.round(selectedColor.r * 255)
                                        if (modelData === "G") return Math.round(selectedColor.g * 255)
                                        return Math.round(selectedColor.b * 255)
                                    }

                                    onEditingFinished: {
                                        var r = modelData === "R" ? parseInt(text) / 255 : selectedColor.r
                                        var g = modelData === "G" ? parseInt(text) / 255 : selectedColor.g
                                        var b = modelData === "B" ? parseInt(text) / 255 : selectedColor.b
                                        internal.updateFromColor(Qt.rgba(r, g, b, internal.alpha))
                                        internal.updateSelectedColor()
                                    }
                                }
                            }
                        }
                    }

                    // Alpha input
                    Rectangle {
                        visible: showAlpha
                        Layout.fillWidth: true
                        Layout.preferredHeight: 36
                        radius: 4
                        color: colors.surfaceContainerHighest
                        border.width: 1
                        border.color: colors.outline

                        Column {
                            anchors.centerIn: parent
                            spacing: 0

                            Text {
                                text: "A"
                                font.family: "Roboto"
                                font.pixelSize: 10
                                color: colors.onSurfaceVariant
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            TextInput {
                                width: 30
                                font.family: "JetBrains Mono, monospace"
                                font.pixelSize: 12
                                color: colors.onSurface
                                horizontalAlignment: Text.AlignHCenter
                                maximumLength: 3
                                validator: IntValidator { bottom: 0; top: 100 }

                                text: Math.round(internal.alpha * 100)

                                onEditingFinished: {
                                    internal.alpha = parseInt(text) / 100
                                    internal.updateSelectedColor()
                                }
                            }
                        }
                    }
                }

                // HSL inputs
                RowLayout {
                    visible: format === "hsl"
                    Layout.fillWidth: true
                    spacing: 4

                    Repeater {
                        model: ["H", "S", "L"]

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 36
                            radius: 4
                            color: colors.surfaceContainerHighest
                            border.width: 1
                            border.color: colors.outline

                            Column {
                                anchors.centerIn: parent
                                spacing: 0

                                Text {
                                    text: modelData
                                    font.family: "Roboto"
                                    font.pixelSize: 10
                                    color: colors.onSurfaceVariant
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                TextInput {
                                    width: 30
                                    font.family: "JetBrains Mono, monospace"
                                    font.pixelSize: 12
                                    color: colors.onSurface
                                    horizontalAlignment: Text.AlignHCenter
                                    maximumLength: 3
                                    validator: IntValidator { bottom: 0; top: modelData === "H" ? 360 : 100 }

                                    text: {
                                        if (modelData === "H") return Math.round(internal.hue * 360)
                                        if (modelData === "S") return Math.round(internal.saturation * 100)
                                        return Math.round(internal.lightness * 100)
                                    }

                                    onEditingFinished: {
                                        if (modelData === "H") internal.hue = parseInt(text) / 360
                                        else if (modelData === "S") internal.saturation = parseInt(text) / 100
                                        else internal.lightness = parseInt(text) / 100
                                        internal.updateSelectedColor()
                                    }
                                }
                            }
                        }
                    }

                    // Alpha input for HSL
                    Rectangle {
                        visible: showAlpha
                        Layout.fillWidth: true
                        Layout.preferredHeight: 36
                        radius: 4
                        color: colors.surfaceContainerHighest
                        border.width: 1
                        border.color: colors.outline

                        Column {
                            anchors.centerIn: parent
                            spacing: 0

                            Text {
                                text: "A"
                                font.family: "Roboto"
                                font.pixelSize: 10
                                color: colors.onSurfaceVariant
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            TextInput {
                                width: 30
                                font.family: "JetBrains Mono, monospace"
                                font.pixelSize: 12
                                color: colors.onSurface
                                horizontalAlignment: Text.AlignHCenter
                                maximumLength: 3
                                validator: IntValidator { bottom: 0; top: 100 }

                                text: Math.round(internal.alpha * 100)

                                onEditingFinished: {
                                    internal.alpha = parseInt(text) / 100
                                    internal.updateSelectedColor()
                                }
                            }
                        }
                    }
                }
            }

            // Preset colors
            Item {
                visible: showPresets
                Layout.fillWidth: true
                Layout.preferredHeight: 60

                Column {
                    anchors.fill: parent
                    spacing: 8

                    Text {
                        text: "Presets"
                        font.family: "Roboto"
                        font.pixelSize: 12
                        color: colors.onSurfaceVariant
                    }

                    Flow {
                        width: parent.width
                        spacing: 6

                        Repeater {
                            model: presetColors

                            Rectangle {
                                width: 24
                                height: 24
                                radius: 4
                                color: modelData
                                border.width: selectedColor.toString() === modelData ? 2 : 0
                                border.color: colors.primary

                                // Checkerboard for white
                                Rectangle {
                                    visible: modelData === "#ffffff"
                                    anchors.fill: parent
                                    anchors.margins: 1
                                    radius: 3
                                    border.width: 1
                                    border.color: colors.outline
                                    color: "transparent"
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        internal.updateFromColor(modelData)
                                        internal.updateSelectedColor()
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // Actions
            RowLayout {
                Layout.fillWidth: true
                Layout.topMargin: 8
                spacing: 8

                Item { Layout.fillWidth: true }

                Item {
                    Layout.preferredWidth: cancelLabel.implicitWidth + 24
                    Layout.preferredHeight: 40

                    Rectangle {
                        anchors.fill: parent
                        radius: 20
                        color: colors.primary
                        opacity: cancelMouse.containsMouse ? 0.08 : 0
                    }

                    Text {
                        id: cancelLabel
                        anchors.centerIn: parent
                        text: "Cancel"
                        font.family: "Roboto"
                        font.pixelSize: 14
                        font.weight: Font.Medium
                        color: colors.primary
                    }

                    MouseArea {
                        id: cancelMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.cancelled()
                    }
                }

                Rectangle {
                    Layout.preferredWidth: selectLabel.implicitWidth + 32
                    Layout.preferredHeight: 40
                    radius: 20
                    color: colors.primary

                    Rectangle {
                        anchors.fill: parent
                        radius: parent.radius
                        color: colors.onPrimary
                        opacity: selectMouse.containsMouse ? 0.12 : 0
                    }

                    Text {
                        id: selectLabel
                        anchors.centerIn: parent
                        text: "Select"
                        font.family: "Roboto"
                        font.pixelSize: 14
                        font.weight: Font.Medium
                        color: colors.onPrimary
                    }

                    MouseArea {
                        id: selectMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: colorSelected(selectedColor)
                    }
                }
            }
        }
    }

    // Public functions
    function getHex() {
        return selectedColor.toString()
    }

    function getRgb() {
        return {
            r: Math.round(selectedColor.r * 255),
            g: Math.round(selectedColor.g * 255),
            b: Math.round(selectedColor.b * 255),
            a: Math.round(internal.alpha * 255)
        }
    }

    function getHsl() {
        return {
            h: Math.round(internal.hue * 360),
            s: Math.round(internal.saturation * 100),
            l: Math.round(internal.lightness * 100),
            a: Math.round(internal.alpha * 100)
        }
    }

    function setColor(c) {
        internal.updateFromColor(c)
        internal.updateSelectedColor()
    }

    function reset() {
        internal.updateFromColor(initialColor)
        internal.updateSelectedColor()
    }

    Accessible.role: Accessible.Dialog
    Accessible.name: "Color picker"
}
