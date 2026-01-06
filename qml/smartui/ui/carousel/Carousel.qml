import QtQuick
import QtQuick.Controls
import "../../theme"

Item {
    id: root

    enum Layout {
        Hero,
        CenterAlignedHero,
        MultiBrowse,
        Uncontained,
        FullScreen
    }

    property int layout: Carousel.Hero
    property var model: null
    property int currentIndex: 0
    property int count: repeater.count
    property bool interactive: true
    property bool autoPlay: false
    property bool autoPlayPaused: false
    property int autoPlayInterval: 5000

    property int itemSpacing: 8
    property int horizontalPadding: layout === Carousel.FullScreen ? 0 : 16
    property int verticalPadding: layout === Carousel.FullScreen ? 0 : 8
    property int itemCornerRadius: layout === Carousel.FullScreen ? 0 : 28
    property int smallItemWidth: 56
    property int mediumItemWidth: 120

    signal itemClicked(int itemIndex, var itemData)
    signal indexChanged(int newIndex)

    implicitWidth: 412
    implicitHeight: layout === Carousel.FullScreen ? 400 : 221

    function next() {
        if (currentIndex < count - 1) goToIndex(currentIndex + 1)
        else if (autoPlay) goToIndex(0)
    }

    function previous() {
        if (currentIndex > 0) goToIndex(currentIndex - 1)
    }

    function goToIndex(idx) {
        idx = Math.max(0, Math.min(idx, count - 1))
        currentIndex = idx
        indexChanged(idx)
        scrollAnim.to = spec.getScrollTarget(idx)
        scrollAnim.restart()
    }

    QtObject {
        id: spec
        
        readonly property real viewWidth: root.width - root.horizontalPadding * 2
        readonly property real viewHeight: root.height - root.verticalPadding * 2
        
        readonly property real largeWidth: {
            switch (root.layout) {
                case Carousel.FullScreen:
                    return root.width
                case Carousel.Hero:
                    return viewWidth - root.smallItemWidth - root.itemSpacing
                case Carousel.CenterAlignedHero:
                    return viewWidth - (root.smallItemWidth * 2) - (root.itemSpacing * 2)
                case Carousel.MultiBrowse:
                    return viewWidth - root.mediumItemWidth - root.smallItemWidth - (root.itemSpacing * 2)
                case Carousel.Uncontained:
                    var cols = Math.max(2, Math.min(4, Math.floor((viewWidth + root.itemSpacing) / 180)))
                    return (viewWidth - (root.itemSpacing * (cols - 1))) / cols
            }
            return viewWidth * 0.7
        }
        
        // Scroll unit - distance to scroll for one item
        readonly property real scrollUnit: largeWidth + root.itemSpacing
        
        function getScrollTarget(idx) {
            if (root.layout === Carousel.CenterAlignedHero) {
                // Center the item
                return idx * scrollUnit
            }
            return idx * scrollUnit
        }
        
        function getMaxScroll() {
            if (root.count <= 1) return 0
            
            // Calculate total content width at rest position
            var total = largeWidth // First item is large
            for (var i = 1; i < root.count; i++) {
                total += root.smallItemWidth + root.itemSpacing
            }
            
            // Max scroll = content - view, but ensure last item fills properly
            var maxScroll = (root.count - 1) * scrollUnit
            
            // For uncontained, limit scroll so last item stays at edge
            if (root.layout === Carousel.Uncontained) {
                var uncontainedTotal = root.count * largeWidth + (root.count - 1) * root.itemSpacing
                maxScroll = Math.max(0, uncontainedTotal - viewWidth)
            }
            
            return maxScroll
        }
        
        // Get width for item based on scroll position (continuous)
        function getItemWidth(index, scrollX) {
            if (root.layout === Carousel.FullScreen) return root.width
            if (root.layout === Carousel.Uncontained) return largeWidth
            
            // Focal position (which item is "current" based on scroll)
            var focalPos = scrollX / scrollUnit
            var diff = index - focalPos
            
            switch (root.layout) {
                case Carousel.Hero:
                case Carousel.CenterAlignedHero:
                    if (diff >= 0 && diff < 1) {
                        return lerp(largeWidth, root.smallItemWidth, diff)
                    } else if (diff >= -1 && diff < 0) {
                        return lerp(largeWidth, root.smallItemWidth, -diff)
                    }
                    return root.smallItemWidth
                    
                case Carousel.MultiBrowse:
                    if (diff >= 0 && diff < 1) {
                        return lerp(largeWidth, root.mediumItemWidth, diff)
                    } else if (diff >= 1 && diff < 2) {
                        return lerp(root.mediumItemWidth, root.smallItemWidth, diff - 1)
                    } else if (diff >= -1 && diff < 0) {
                        return lerp(largeWidth, root.mediumItemWidth, -diff)
                    } else if (diff >= -2 && diff < -1) {
                        return lerp(root.mediumItemWidth, root.smallItemWidth, -diff - 1)
                    }
                    return root.smallItemWidth
            }
            return root.smallItemWidth
        }
        
        // Get X position for item
        function getItemX(index, scrollX) {
            var x = 0
            for (var i = 0; i < index; i++) {
                x += getItemWidth(i, scrollX) + root.itemSpacing
            }
            
            // Apply centering offset for CenterAlignedHero
            if (root.layout === Carousel.CenterAlignedHero) {
                var focalIdx = Math.round(scrollX / scrollUnit)
                focalIdx = clamp(focalIdx, 0, root.count - 1)
                var focalWidth = getItemWidth(focalIdx, scrollX)
                var centerOffset = (viewWidth - focalWidth) / 2
                
                // Calculate where focal item currently is
                var focalX = 0
                for (var j = 0; j < focalIdx; j++) {
                    focalX += getItemWidth(j, scrollX) + root.itemSpacing
                }
                
                // Adjust all positions to center the focal item
                var adjustment = centerOffset - focalX + scrollX
                x += adjustment
            }
            
            return x - scrollX
        }
        
        function lerp(a, b, t) {
            return a + (b - a) * clamp(t, 0, 1)
        }
        
        function clamp(v, min, max) {
            return Math.max(min, Math.min(max, v))
        }
        
        function getItemSize(width) {
            var ratio = width / largeWidth
            if (ratio > 0.7) return "large"
            if (ratio > 0.35) return "medium"
            return "small"
        }
    }

    Timer {
        running: root.autoPlay && !root.autoPlayPaused && root.count > 1 && !dragArea.pressed && !scrollAnim.running
        interval: root.autoPlayInterval
        repeat: true
        onTriggered: root.next()
    }

    NumberAnimation {
        id: scrollAnim
        target: flickable
        property: "contentX"
        duration: 350
        easing.type: Easing.OutCubic
    }

    Item {
        id: container
        anchors.fill: parent
        anchors.leftMargin: root.horizontalPadding
        anchors.rightMargin: root.layout === Carousel.Uncontained ? 0 : root.horizontalPadding
        anchors.topMargin: root.verticalPadding
        anchors.bottomMargin: root.verticalPadding
        clip: true

        // Use Flickable for smooth scrolling
        Flickable {
            id: flickable
            anchors.fill: parent
            
            contentWidth: parent.width * 2 // Will be managed manually
            contentHeight: height
            boundsBehavior: Flickable.StopAtBounds
            
            // Disable Flickable's own interaction - we handle it manually
            interactive: false

            Item {
                id: itemContainer
                width: flickable.contentWidth
                height: flickable.height

                Repeater {
                    id: repeater
                    model: root.model

                    delegate: Item {
                        id: del
                        
                        required property int index
                        required property var modelData
                        
                        // Computed based on scroll position
                        property real scrollX: flickable.contentX
                        property real itemWidth: spec.getItemWidth(index, scrollX)
                        property real itemX: spec.getItemX(index, scrollX)
                        
                        x: itemX
                        y: 0
                        width: itemWidth
                        height: itemContainer.height
                        
                        visible: x + width > -50 && x < container.width + 50

                        CarouselItem {
                            anchors.fill: parent
                            
                            itemIndex: del.index
                            itemData: del.modelData
                            radius: root.itemCornerRadius
                            itemSize: spec.getItemSize(del.itemWidth)
                            
                            parallaxOffset: {
                                if (root.layout === Carousel.FullScreen || root.layout === Carousel.Uncontained) return 0
                                var center = del.x + del.width / 2
                                var viewCenter = container.width / 2
                                return (center - viewCenter) / container.width * 0.4
                            }

                            onClicked: {
                                var targetIdx = Math.round(flickable.contentX / spec.scrollUnit)
                                if (del.index === targetIdx) {
                                    root.itemClicked(del.index, del.modelData)
                                } else {
                                    root.goToIndex(del.index)
                                }
                            }
                        }
                    }
                }
            }
        }

        // Manual drag handling for better control
        MouseArea {
            id: dragArea
            anchors.fill: parent
            enabled: root.interactive
            
            property real startX: 0
            property real startContentX: 0
            property real velocity: 0
            property real lastX: 0
            property real lastTime: 0

            onPressed: function(mouse) {
                scrollAnim.stop()
                startX = mouse.x
                startContentX = flickable.contentX
                lastX = mouse.x
                lastTime = Date.now()
                velocity = 0
                
                if (root.autoPlay) root.autoPlayPaused = true
            }

            onPositionChanged: function(mouse) {
                var now = Date.now()
                var dt = now - lastTime
                if (dt > 0) {
                    velocity = (mouse.x - lastX) / dt * 1000
                }
                lastX = mouse.x
                lastTime = now
                
                var dx = startX - mouse.x
                var newX = startContentX + dx
                
                // Clamp with rubber band effect
                var maxScroll = spec.getMaxScroll()
                if (newX < 0) {
                    newX = newX * 0.3
                } else if (newX > maxScroll) {
                    newX = maxScroll + (newX - maxScroll) * 0.3
                }
                
                flickable.contentX = newX
            }

            onReleased: {
                var targetIdx = Math.round(flickable.contentX / spec.scrollUnit)
                
                // Velocity-based fling
                if (Math.abs(velocity) > 300) {
                    if (velocity > 0) {
                        targetIdx = Math.floor(flickable.contentX / spec.scrollUnit)
                    } else {
                        targetIdx = Math.ceil(flickable.contentX / spec.scrollUnit)
                    }
                }
                
                // Clamp and snap
                targetIdx = spec.clamp(targetIdx, 0, root.count - 1)
                root.goToIndex(targetIdx)
            }

            onCanceled: {
                var targetIdx = Math.round(flickable.contentX / spec.scrollUnit)
                targetIdx = spec.clamp(targetIdx, 0, root.count - 1)
                root.goToIndex(targetIdx)
            }
        }
    }

    // Indicators
    Row {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 14
        spacing: 8
        visible: showIndicators && root.count > 1 && root.count <= 10
        
        property bool showIndicators: root.layout === Carousel.Hero || 
                                      root.layout === Carousel.CenterAlignedHero || 
                                      root.layout === Carousel.FullScreen

        Repeater {
            model: root.count

            Rectangle {
                required property int index
                
                width: index === root.currentIndex ? 20 : 8
                height: 8
                radius: 4
                color: ChiTheme.colors.inverseSurface
                opacity: index === root.currentIndex ? 1 : 0.38

                Behavior on width { 
                    NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
                }
                Behavior on opacity { 
                    NumberAnimation { duration: 150 } 
                }

                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -8
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.goToIndex(parent.index)
                }
            }
        }
    }

    // Auto-play button
    Rectangle {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 16
        width: 40
        height: 40
        radius: 20
        color: Qt.rgba(0, 0, 0, 0.5)
        visible: root.autoPlay && root.count > 1

        Text {
            anchors.centerIn: parent
            text: root.autoPlayPaused ? "▶" : "⏸"
            font.pixelSize: 14
            color: "#FFFFFF"
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: root.autoPlayPaused = !root.autoPlayPaused
        }
    }

    Accessible.role: Accessible.List
    Accessible.name: qsTr("Carousel with %1 items").arg(count)
}
