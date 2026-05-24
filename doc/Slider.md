# Slider

## Component Overview

Slider is a range selection component following Material Design 3 guidelines. It allows users to select a value within a defined range by dragging a thumb along a track. The slider supports horizontal and vertical orientations, configurable step size, optional value indicator, discrete stop markers, an optional leading icon, and five sizes.

## Properties

| Property | Type | Default | Description |
|---|---|---|---|
| value | real | 0 | The current value of the slider |
| from | real | 0 | The minimum value of the slider range |
| to | real | 100 | The maximum value of the slider range |
| stepSize | real | 0 | The step size for discrete values; 0 means continuous |
| enabled | bool | true | Whether the slider is interactive |
| size | string | "medium" | Size of the slider. Accepted values: "xs", "small", "medium", "large", "xl" |
| orientation | string | "horizontal" | Orientation of the slider. Accepted values: "horizontal", "vertical" |
| showValueIndicator | string | "never" | When to show the value indicator bubble. Accepted values: "never", "always", "auto" (shows while dragging) |
| showStops | bool | false | Whether to show discrete stop markers along the track |
| icon | string | | Optional icon source displayed at the start of the slider |

## Signals

| Signal | Description |
|---|---|
| moved() | Emitted when the slider value changes due to user interaction |

## Methods

This component has no additional methods beyond standard QML Item behavior.

## Usage Example

```qml
import Chi 0.1

Slider {
    id: volumeSlider
    from: 0
    to: 100
    value: 50
    stepSize: 5
    orientation: "horizontal"
    showValueIndicator: "auto"
    showStops: true
    icon: "icons/volume.svg"

    onMoved: {
        console.log("Volume:", value)
    }
}
```
