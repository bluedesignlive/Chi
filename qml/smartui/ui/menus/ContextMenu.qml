import QtQuick
import "../../theme" as Theme

Menu {
    id: root

    property point position: Qt.point(0, 0)

    x: position.x
    y: position.y

    // Ensure menu stays within parent bounds
    onOpenChanged: {
        if (open && parent) {
            // Adjust horizontal position
            if (x + width > parent.width) {
                x = parent.width - width - 8
            }
            if (x < 8) x = 8

            // Adjust vertical position
            if (y + height > parent.height) {
                y = parent.height - height - 8
            }
            if (y < 8) y = 8
        }
    }

    function popup(px, py) {
        position = Qt.point(px, py)
        show()
    }
}
