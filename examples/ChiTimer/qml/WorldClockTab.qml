import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Chi

Item {
    id: root

    readonly property var colors: ChiTheme.colors
    readonly property string fontFamily: ChiTheme.fontFamily

    property var cities: [
        { name: "London",       offset: 0    },
        { name: "New York",     offset: -4   },
        { name: "Tokyo",        offset: 9    },
        { name: "Sydney",       offset: 10   },
        { name: "Dubai",        offset: 4    },
        { name: "Paris",        offset: 2    },
        { name: "Los Angeles",  offset: -7   },
        { name: "Shanghai",     offset: 8    },
        { name: "Mumbai",       offset: 5.5  },
        { name: "Berlin",       offset: 2    }
    ]

    property string filterText: ""
    property int _tick: 0

    Timer {
        interval: 1000
        repeat: true
        running: true
        onTriggered: root._tick++
    }

    SearchBar {
        id: searchBar
        placeholderText: "Search cities..."
        leadingIcon: "location_city"
        showTrailingIcon: false
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 16
        onTextChanged: root.filterText = text
        onCleared: root.filterText = ""
    }

    ListView {
        id: cityList
        anchors.top: searchBar.bottom
        anchors.topMargin: 8
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: 16
        anchors.rightMargin: 16
        clip: true
        spacing: 8
        model: root.cities

        delegate: Item {
            required property var modelData
            required property int index

            width: cityList.width
            height: 100
            visible: {
                if (root.filterText === "") return true
                return modelData.name.toLowerCase().indexOf(root.filterText.toLowerCase()) >= 0
            }

            Rectangle {
                anchors.fill: parent
                radius: 16
                color: colors.surfaceContainerLow

                Column {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    spacing: 2

                    Label {
                        text: modelData.name
                        font.family: root.fontFamily
                        font.pixelSize: 16
                        font.weight: Font.Medium
                        color: colors.onSurface
                    }

                    Label {
                        text: getCityDate(modelData.offset, _tick)
                        font.family: root.fontFamily
                        font.pixelSize: 13
                        color: colors.onSurfaceVariant
                    }

                    Label {
                        text: "UTC" + (modelData.offset >= 0 ? "+" : "") + modelData.offset
                        font.family: root.fontFamily
                        font.pixelSize: 11
                        color: colors.onSurfaceVariant
                    }
                }

                Label {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 20
                    text: getCityTime(modelData.offset, _tick)
                    font.family: root.fontFamily
                    font.pixelSize: 32
                    font.weight: Font.Light
                    color: colors.onSurface
                }
            }
        }

        Label {
            anchors.centerIn: parent
            text: "No cities match your search"
            font.family: root.fontFamily
            font.pixelSize: 16
            color: colors.onSurfaceVariant
            visible: {
                if (root.filterText === "") return false
                var hasVisible = false
                for (var i = 0; i < root.cities.length; i++) {
                    if (root.cities[i].name.toLowerCase().indexOf(root.filterText.toLowerCase()) >= 0) {
                        hasVisible = true
                        break
                    }
                }
                return !hasVisible
            }
        }
    }

    function getCityTime(offset, _) {
        var now = new Date()
        var utc = now.getTime() + now.getTimezoneOffset() * 60000
        var city = new Date(utc + offset * 3600000)
        return pad(city.getHours()) + ":" + pad(city.getMinutes())
    }

    function getCityDate(offset, _) {
        var now = new Date()
        var utc = now.getTime() + now.getTimezoneOffset() * 60000
        var city = new Date(utc + offset * 3600000)
        var days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
                      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        return days[city.getDay()] + ", " + city.getDate() + " " + months[city.getMonth()]
    }

    function pad(n) {
        return String(n).padStart(2, '0')
    }
}
