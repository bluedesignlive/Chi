# LinearProgressIndicator

A horizontal progress bar. Supports determinate, indeterminate, and stop-indicator modes per Material 3 specifications.

## Properties

| Property | Type | Default | Description |
|---|---|---|---|
| progress | real | 0.0 | Current progress value (0.0 to 1.0 for determinate) |
| indeterminate | bool | false | Show indeterminate (looping) animation |
| trackThickness | real | 4 | Thickness of the track in pixels |
| showStopIndicator | bool | true | Show the stop/segment indicator at the end |
| enabled | bool | true | Whether the track is rendered |

## Methods

**setProgress(value)** — Set the progress value.

**reset()** — Reset progress to 0.

**complete()** — Set progress to 1.0.

## Usage Example

```qml
LinearProgressIndicator {
    id: progressBar
    progress: 0.5
    indeterminate: false
}

// Update:
progressBar.setProgress(0.75)
```
