// qml/smartui/ui/common/SmoothRectangle.qml

import QtQuick
import QtQuick.Shapes

Item {
    id: root

    property real radius: 24
    property real smoothness: 0.6      // 0 = regular rounded, 1 = full squircle
    property color color: "white"
    property color borderColor: "transparent"
    property real borderWidth: 0

    Shape {
        id: shape
        anchors.fill: parent

        // High quality antialiasing
        layer.enabled: true
        layer.samples: 8
        layer.smooth: true
        antialiasing: true
        smooth: true

        ShapePath {
            id: path

            fillColor: root.color
            strokeColor: root.borderColor
            strokeWidth: root.borderWidth

            // Clamp radius to half of smallest dimension
            readonly property real r: Math.min(root.radius, Math.min(root.width, root.height) / 2)
            readonly property real w: root.width
            readonly property real h: root.height

            // Bezier control point factor
            // 0.552 = standard quarter circle approximation
            // Higher values = more squircle (control points closer to corner)
            // Apple uses approximately 0.6-0.7 for iOS corners
            readonly property real kappa: 0.552 + (root.smoothness * 0.3)

            // Clamp to prevent overshooting
            readonly property real k: Math.min(kappa, 0.95)

            // Control point distance from start/end of curve
            readonly property real d: r * k

            startX: r
            startY: 0

            // ═══ TOP EDGE ═══
            PathLine {
                x: path.w - path.r
                y: 0
            }

            // ═══ TOP-RIGHT CORNER ═══
            // From (w-r, 0) to (w, r), corner at (w, 0)
            PathCubic {
                x: path.w
                y: path.r

                // Control 1: from start, move toward corner (right)
                control1X: path.w - path.r + path.d
                control1Y: 0

                // Control 2: from end, move toward corner (up)
                control2X: path.w
                control2Y: path.r - path.d
            }

            // ═══ RIGHT EDGE ═══
            PathLine {
                x: path.w
                y: path.h - path.r
            }

            // ═══ BOTTOM-RIGHT CORNER ═══
            // From (w, h-r) to (w-r, h), corner at (w, h)
            PathCubic {
                x: path.w - path.r
                y: path.h

                // Control 1: from start, move toward corner (down)
                control1X: path.w
                control1Y: path.h - path.r + path.d

                // Control 2: from end, move toward corner (right)
                control2X: path.w - path.r + path.d
                control2Y: path.h
            }

            // ═══ BOTTOM EDGE ═══
            PathLine {
                x: path.r
                y: path.h
            }

            // ═══ BOTTOM-LEFT CORNER ═══
            // From (r, h) to (0, h-r), corner at (0, h)
            PathCubic {
                x: 0
                y: path.h - path.r

                // Control 1: from start, move toward corner (left)
                control1X: path.r - path.d
                control1Y: path.h

                // Control 2: from end, move toward corner (down)
                control2X: 0
                control2Y: path.h - path.r + path.d
            }

            // ═══ LEFT EDGE ═══
            PathLine {
                x: 0
                y: path.r
            }

            // ═══ TOP-LEFT CORNER ═══
            // From (0, r) to (r, 0), corner at (0, 0)
            PathCubic {
                x: path.r
                y: 0

                // Control 1: from start, move toward corner (up)
                control1X: 0
                control1Y: path.r - path.d

                // Control 2: from end, move toward corner (left)
                control2X: path.r - path.d
                control2Y: 0
            }
        }
    }
}
