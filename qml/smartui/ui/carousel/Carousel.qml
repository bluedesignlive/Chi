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
    property alias count: repeater.count
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
        progressAnim.stop()
        progressAnim.from = priv.progress
        progressAnim.to = idx
        progressAnim.start()
        currentIndex = idx
        indexChanged(idx)
    }

    QtObject {
        id: priv
        
        property real progress: 0.0
        
        property real viewWidth: root.width - root.horizontalPadding * 2
        property real viewHeight: root.height - root.verticalPadding * 2
        
        property real largeItemWidth: {
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
                default:
                    return viewWidth * 0.7
            }
        }
        
        // Maximum scroll progress - prevents gaps at end
        property real maxProgress: {
            if (root.count <= 1) return 0
            
            switch (root.layout) {
                case Carousel.Uncontained:
                    // Calculate how many items fit, don't allow scrolling past last item
                    var totalWidth = root.count * largeItemWidth + (root.count - 1) * root.itemSpacing
                    var maxScroll = totalWidth - viewWidth
                    if (maxScroll <= 0) return 0
                    return maxScroll / (largeItemWidth + root.itemSpacing)
                    
                case Carousel.CenterAlignedHero:
                case Carousel.Hero:
                case Carousel.MultiBrowse:
                case Carousel.FullScreen:
                    return root.count - 1
            }
            return root.count - 1
        }
        
        function clamp(val, min, max) {
            return Math.max(min, Math.min(max, val))
        }
        
        function lerp(a, b, t) {
            return a + (b - a) * clamp(t, 0, 1)
        }
        
        function getItemWidth(index) {
            var diff = index - progress
            
            switch (root.layout) {
                case Carousel.FullScreen:
                    return root.width
                    
                case Carousel.Uncontained:
                    return largeItemWidth
                    
                case Carousel.Hero:
                    // At edges, keep proper sizes
                    if (progress <= 0 && index === 0) return largeItemWidth
                    if (progress >= root.count - 1 && index === root.count - 1) return largeItemWidth
                    
                    if (diff >= 0 && diff < 1) {
                        return lerp(largeItemWidth, root.smallItemWidth, diff)
                    } else if (diff > -1 && diff < 0) {
                        return lerp(largeItemWidth, root.smallItemWidth, -diff)
                    }
                    return root.smallItemWidth
                    
                case Carousel.CenterAlignedHero:
                    if (progress <= 0 && index === 0) return largeItemWidth
                    if (progress >= root.count - 1 && index === root.count - 1) return largeItemWidth
                    
                    if (diff >= 0 && diff < 1) {
                        return lerp(largeItemWidth, root.smallItemWidth, diff)
                    } else if (diff > -1 && diff < 0) {
                        return lerp(largeItemWidth, root.smallItemWidth, -diff)
                    }
                    return root.smallItemWidth
                    
                case Carousel.MultiBrowse:
                    if (progress <= 0 && index === 0) return largeItemWidth
                    if (progress >= root.count - 1 && index === root.count - 1) return largeItemWidth
                    
                    if (diff >= 0 && diff < 1) {
                        return lerp(largeItemWidth, root.mediumItemWidth, diff)
                    } else if (diff >= 1 && diff < 2) {
                        return lerp(root.mediumItemWidth, root.smallItemWidth, diff - 1)
                    } else if (diff > -1 && diff < 0) {
                        return lerp(largeItemWidth, root.smallItemWidth, -diff)
                    }
                    return root.smallItemWidth
            }
            return root.smallItemWidth
        }
        
        function getItemX(index) {
            switch (root.layout) {
                case Carousel.Uncontained:
                    return getUncontainedX(index)
                case Carousel.CenterAlignedHero:
                    return getCenterAlignedX(index)
                case Carousel.Hero:
                case Carousel.MultiBrowse:
                    return getHeroX(index)
                case Carousel.FullScreen:
                    return getFullScreenX(index)
            }
            return 0
        }
        
        function getUncontainedX(index) {
            var x = index * (largeItemWidth + root.itemSpacing)
            var scrollOffset = progress * (largeItemWidth + root.itemSpacing)
            
            // Clamp scroll so last item stays at right edge
            var totalWidth = root.count * largeItemWidth + (root.count - 1) * root.itemSpacing
            var maxScrollOffset = Math.max(0, totalWidth - viewWidth)
            scrollOffset = Math.min(scrollOffset, maxScrollOffset)
            
            return x - scrollOffset
        }
        
        function getCenterAlignedX(index) {
            // Sum widths before this item
            var x = 0
            for (var i = 0; i < index; i++) {
                x += getItemWidth(i) + root.itemSpacing
            }
            
            // Calculate where focal item should be centered
            var focalWidth = getItemWidth(Math.round(progress))
            var sideSpace = (viewWidth - focalWidth) / 2
            
            // Scroll offset
            var scrollOffset = 0
            var floorP = Math.floor(progress)
            var fracP = progress - floorP
            
            for (var j = 0; j < floorP; j++) {
                scrollOffset += getItemWidth(j) + root.itemSpacing
            }
            scrollOffset += fracP * (getItemWidth(floorP) + root.itemSpacing)
            
            // Base position
            var baseX = x - scrollOffset + sideSpace
            
            // At first item - align to left edge (no gap on left)
            if (progress <= 0) {
                return index * (root.smallItemWidth + root.itemSpacing)
                       + (index === 0 ? 0 : (largeItemWidth - root.smallItemWidth))
            }
            
            // At last item - no gap on right
            if (progress >= root.count - 1) {
                var totalW = 0
                for (var k = 0; k < root.count; k++) {
                    totalW += getItemWidth(k) + (k < root.count - 1 ? root.itemSpacing : 0)
                }
                var rightAlignOffset = viewWidth - totalW
                var px = rightAlignOffset
                for (var m = 0; m < index; m++) {
                    px += getItemWidth(m) + root.itemSpacing
                }
                return px
            }
            
            return baseX
        }
        
        function getHeroX(index) {
            var x = 0
            for (var i = 0; i < index; i++) {
                x += getItemWidth(i) + root.itemSpacing
            }
            
            var scrollOffset = 0
            var floorP = Math.floor(progress)
            var fracP = progress - floorP
            
            for (var j = 0; j < floorP; j++) {
                scrollOffset += getItemWidth(j) + root.itemSpacing
            }
            scrollOffset += fracP * (getItemWidth(floorP) + root.itemSpacing)
            
            // At last item - ensure it fills to right edge
            if (progress >= root.count - 1) {
                var totalW = 0
                for (var k = 0; k < root.count; k++) {
                    totalW += getItemWidth(k) + (k < root.count - 1 ? root.itemSpacing : 0)
                }
                scrollOffset = totalW - viewWidth
            }
            
            // At first item - no scroll
            if (progress <= 0) {
                scrollOffset = 0
            }
            
            return x - scrollOffset
        }
        
        function getFullScreenX(index) {
            return (index - progress) * root.width
        }
        
        function getItemSize(width) {
            var ratio = width / largeItemWidth
            if (ratio > 0.65) return "large"
            if (ratio > 0.3) return "medium"
            return "small"
        }
        
        function getParallax(x, width, containerWidth) {
            if (root.layout === Carousel.FullScreen || root.layout === Carousel.Uncontained) {
                return 0
            }
            var center = x + width / 2
            var viewCenter = containerWidth / 2
            return (center - viewCenter) / containerWidth * 0.4
        }
    }
    
    NumberAnimation {
        id: progressAnim
        target: priv
        property: "progress"
        duration: 320
        easing.type: Easing.OutCubic
    }
    
    Timer {
        running: root.autoPlay && !root.autoPlayPaused && root.count > 1 && 
                 !dragHandler.active && !progressAnim.running
        interval: root.autoPlayInterval
        repeat: true
        onTriggered: root.next()
    }

    Item {
        id: container
        anchors.fill: parent
        anchors.leftMargin: root.horizontalPadding
        anchors.rightMargin: root.layout === Carousel.Uncontained ? 0 : root.horizontalPadding
        anchors.topMargin: root.verticalPadding
        anchors.bottomMargin: root.verticalPadding
        clip: true

        DragHandler {
            id: dragHandler
            target: null
            xAxis.enabled: true
            yAxis.enabled: false
            
            property real startProgress: 0
            
            onActiveChanged: {
                if (active) {
                    progressAnim.stop()
                    startProgress = priv.progress
                    if (root.autoPlay) root.autoPlayPaused = true
                } else {
                    var targetIdx
                    
                    if (root.layout === Carousel.Uncontained) {
                        // For uncontained, snap based on scroll position
                        targetIdx = Math.round(priv.progress)
                        if (Math.abs(centroid.velocity.x) > 300) {
                            if (centroid.velocity.x > 0) targetIdx = Math.floor(priv.progress)
                            else targetIdx = Math.ceil(priv.progress)
                        }
                    } else {
                        targetIdx = Math.round(priv.progress)
                        if (Math.abs(centroid.velocity.x) > 300) {
                            if (centroid.velocity.x > 0) targetIdx = Math.floor(priv.progress)
                            else targetIdx = Math.ceil(priv.progress)
                        }
                    }
                    
                    root.goToIndex(targetIdx)
                }
            }
            
            onTranslationChanged: {
                if (!active) return
                var dragScale = priv.largeItemWidth + root.itemSpacing
                var delta = -translation.x / dragScale
                var newProgress = startProgress + delta
                
                // Clamp progress based on layout
                priv.progress = priv.clamp(newProgress, 0, priv.maxProgress)
            }
        }

        Repeater {
            id: repeater
            model: root.model

            delegate: CarouselItem {
                id: itemDelegate
                
                required property int index
                required property var modelData

                property real itemWidth: priv.getItemWidth(index)
                property real itemX: priv.getItemX(index)

                x: itemX
                y: 0
                width: itemWidth
                height: container.height
                
                visible: itemX > -itemWidth - 50 && itemX < container.width + 50

                itemIndex: index
                itemData: modelData
                itemSize: priv.getItemSize(itemWidth)
                radius: root.itemCornerRadius
                parallaxOffset: priv.getParallax(itemX, itemWidth, container.width)

                onClicked: {
                    if (Math.abs(index - priv.progress) < 0.35) {
                        root.itemClicked(index, modelData)
                    } else {
                        root.goToIndex(index)
                    }
                }
            }
        }
    }

    Row {
        id: indicators
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 14
        spacing: 8
        visible: showIndicators && root.count > 1
        
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
                    NumberAnimation { duration: 220; easing.type: Easing.OutCubic } 
                }
                Behavior on opacity { 
                    NumberAnimation { duration: 180 } 
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
