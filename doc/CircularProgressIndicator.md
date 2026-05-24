# CircularProgressIndicator

A circular progress spinner. Supports determinate and indeterminate modes with configurable size. Slots allow custom content in the center.

## Properties

| Property | Type | Default | Description |
|---|---|---|---|
| progress | real | 0.0 | Current progress value (0.0 to 1.0 for determinate) |
| indeterminate | bool | false | Show indeterminate (looping) animation |
| size | string | "medium" | Spinner size. Values: "small", "medium", "large", "xlarge" |
| enabled | bool | true | Whether the spinner is rendered |
| diameter | real | spec-dependent | Outer diameter in pixels |
| strokeWidth | real | spec-dependent | Thickness of the progress arc |

## Aliases

**content** — Default property. Place children in the center of the spinner.

## Methods

**setProgress(value)** — Set the progress value.

**reset()** — Reset progress to 0 and stop animation.

**complete()** — Set progress to 1.0 and stop animation.

## Usage Example

```qml
CircularProgressIndicator {
    size: "large"
    progress: uploadProgress
    
    Label {
        text: Math.round(uploadProgress * 100) + "%"
        anchors.centerIn: parent
    }
}
```
