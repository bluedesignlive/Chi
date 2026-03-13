import QtQuick
import QtQuick.Layouts
import "../../theme" as Theme

Rectangle {
    id: root

    property var columns: []                 // [{key: "", label: "", width: 100, sortable: true, align: "left"}]
    property var rows: []
    property bool showCheckboxes: false
    property bool sortable: true
    property string sortColumn: ""
    property bool sortAscending: true
    property var selectedRows: []
    property bool stickyHeader: true
    property bool striped: false
    property bool hoverable: true
    property bool bordered: false

    signal rowClicked(int index, var row)
    signal rowDoubleClicked(int index, var row)
    signal selectionChanged(var selectedRows)
    signal sortChanged(string column, bool ascending)

    implicitWidth: 600
    implicitHeight: 400

    property var colors: Theme.ChiTheme.colors

    color: colors.surface
    radius: 12
    border.width: bordered ? 1 : 0
    border.color: colors.outlineVariant

    Behavior on color {
        ColorAnimation { duration: 200 }
    }

    clip: true

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Header
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 56
            color: colors.surface
            z: stickyHeader ? 1 : 0

            Behavior on color {
                ColorAnimation { duration: 200 }
            }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 16
                anchors.rightMargin: 16
                spacing: 0

                // Select all checkbox
                Item {
                    visible: showCheckboxes
                    Layout.preferredWidth: 48
                    Layout.preferredHeight: 48

                    Rectangle {
                        anchors.centerIn: parent
                        width: 20
                        height: 20
                        radius: 2
                        color: selectedRows.length === rows.length && rows.length > 0 ? colors.primary : "transparent"
                        border.width: selectedRows.length === rows.length && rows.length > 0 ? 0 : 2
                        border.color: selectedRows.length > 0 ? colors.primary : colors.onSurfaceVariant

                        Text {
                            visible: selectedRows.length === rows.length && rows.length > 0
                            anchors.centerIn: parent
                            text: "✓"
                            font.pixelSize: 16
                            font.weight: Font.Bold
                            color: colors.onPrimary
                        }

                        Text {
                            visible: selectedRows.length > 0 && selectedRows.length < rows.length
                            anchors.centerIn: parent
                            text: "─"
                            font.pixelSize: 16
                            font.weight: Font.Bold
                            color: colors.primary
                        }

                        MouseArea {
                            anchors.fill: parent
                            anchors.margins: -8
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (selectedRows.length === rows.length) {
                                    selectedRows = []
                                } else {
                                    var all = []
                                    for (var i = 0; i < rows.length; i++) all.push(i)
                                    selectedRows = all
                                }
                                selectionChanged(selectedRows)
                            }
                        }
                    }
                }

                // Column headers
                Repeater {
                    model: columns

                    Item {
                        Layout.preferredWidth: modelData.width || 100
                        Layout.fillWidth: modelData.width === undefined
                        Layout.fillHeight: true

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 16
                            anchors.rightMargin: 16
                            spacing: 8

                            Item {
                                visible: modelData.align === "right"
                                Layout.fillWidth: true
                            }

                            Text {
                                text: modelData.label || modelData.key
                                font.family: "Roboto"
                                font.pixelSize: 14
                                font.weight: Font.Medium
                                color: colors.onSurfaceVariant
                                Layout.alignment: modelData.align === "center" ? Qt.AlignHCenter :
                                    (modelData.align === "right" ? Qt.AlignRight : Qt.AlignLeft)

                                Behavior on color {
                                    ColorAnimation { duration: 200 }
                                }
                            }

                            Text {
                                visible: sortable && (modelData.sortable !== false) && sortColumn === modelData.key
                                text: sortAscending ? "▲" : "▼"
                                font.pixelSize: 10
                                color: colors.primary
                            }

                            Item {
                                visible: modelData.align !== "right"
                                Layout.fillWidth: true
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            enabled: sortable && (modelData.sortable !== false)
                            cursorShape: sortable ? Qt.PointingHandCursor : Qt.ArrowCursor
                            onClicked: {
                                if (sortColumn === modelData.key) {
                                    sortAscending = !sortAscending
                                } else {
                                    sortColumn = modelData.key
                                    sortAscending = true
                                }
                                sortChanged(sortColumn, sortAscending)
                            }
                        }
                    }
                }
            }

            // Header divider
            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: 1
                color: colors.outlineVariant
            }
        }

        // Body
        Flickable {
            Layout.fillWidth: true
            Layout.fillHeight: true
            contentHeight: bodyColumn.implicitHeight
            clip: true
            boundsBehavior: Flickable.StopAtBounds

            Column {
                id: bodyColumn
                width: parent.width

                Repeater {
                    model: rows

                    Rectangle {
                        width: parent.width
                        height: 52

                        property bool isSelected: selectedRows.indexOf(index) !== -1

                        color: {
                            if (isSelected) return colors.primaryContainer
                            if (striped && index % 2 === 1) return colors.surfaceContainerLow
                            return "transparent"
                        }

                        Behavior on color {
                            ColorAnimation { duration: 150 }
                        }

                        // Hover state
                        Rectangle {
                            anchors.fill: parent
                            color: colors.onSurface
                            opacity: hoverable && rowMouse.containsMouse && !isSelected ? 0.08 : 0

                            Behavior on opacity {
                                NumberAnimation { duration: 100 }
                            }
                        }

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 16
                            anchors.rightMargin: 16
                            spacing: 0

                            // Row checkbox
                            Item {
                                visible: showCheckboxes
                                Layout.preferredWidth: 48
                                Layout.preferredHeight: 48

                                Rectangle {
                                    anchors.centerIn: parent
                                    width: 20
                                    height: 20
                                    radius: 2
                                    color: isSelected ? colors.primary : "transparent"
                                    border.width: isSelected ? 0 : 2
                                    border.color: colors.onSurfaceVariant

                                    Text {
                                        visible: isSelected
                                        anchors.centerIn: parent
                                        text: "✓"
                                        font.pixelSize: 16
                                        font.weight: Font.Bold
                                        color: colors.onPrimary
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        anchors.margins: -8
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            var sel = selectedRows.slice()
                                            var idx = sel.indexOf(index)
                                            if (idx !== -1) {
                                                sel.splice(idx, 1)
                                            } else {
                                                sel.push(index)
                                            }
                                            selectedRows = sel
                                            selectionChanged(selectedRows)
                                        }
                                    }
                                }
                            }

                            // Cell values
                            Repeater {
                                model: columns

                                Item {
                                    Layout.preferredWidth: modelData.width || 100
                                    Layout.fillWidth: modelData.width === undefined
                                    Layout.fillHeight: true

                                    Text {
                                        anchors.fill: parent
                                        anchors.leftMargin: 16
                                        anchors.rightMargin: 16
                                        text: rows[index][modelData.key] || ""
                                        font.family: "Roboto"
                                        font.pixelSize: 14
                                        color: colors.onSurface
                                        elide: Text.ElideRight
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: modelData.align === "center" ? Text.AlignHCenter :
                                            (modelData.align === "right" ? Text.AlignRight : Text.AlignLeft)

                                        Behavior on color {
                                            ColorAnimation { duration: 200 }
                                        }
                                    }
                                }
                            }
                        }

                        // Row divider
                        Rectangle {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.bottom: parent.bottom
                            height: 1
                            color: colors.outlineVariant
                            visible: index < rows.length - 1
                        }

                        MouseArea {
                            id: rowMouse
                            anchors.fill: parent
                            hoverEnabled: hoverable
                            cursorShape: Qt.PointingHandCursor

                            onClicked: rowClicked(index, rows[index])
                            onDoubleClicked: rowDoubleClicked(index, rows[index])
                        }
                    }
                }
            }
        }
    }

    Accessible.role: Accessible.Table
    Accessible.name: "Data table"
}
