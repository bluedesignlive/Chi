# ChiTimer — Material 3 Expressive Clock

A stopwatch app built with the **Chi UI Toolkit** for Qt6/QML. Demonstrates:

- **Segmented ring progress** (seconds + minutes arcs on canvas)
- **Hero expressive typography** (72-76pt with weight + size morph on state change)
- **Spring-driven motion** (ChiMotion tokens, Bezier curves, OutBack easing)
- **Morphing bottom navigation** (pill indicator slides between tabs)
- **Lap list** (Chi ListItem with segments)

## Screenshot

*(Add screenshot here once running)*

## Build

### Prerequisites

- Qt 6.5+
- Chi UI library built/installed

### Build Steps

```bash
cd examples/ChiTimer
mkdir build && cd build
cmake .. -DQt6_DIR=/path/to/qt6/cmake
make -j$(nproc)
./chitimer
```

### QML Live Reload (dev)

```bash
qml Main.qml  # requires Chi in QML import path
```

## Code Structure

```
ChiTimer/
├── CMakeLists.txt       # Build config
├── src/
│   └── main.cpp         # Entry point
└── qml/
    └── Main.qml         # Single-file app (all demo logic)
```

All UI is in `Main.qml` — a single file demonstrating every Chi concept.

## Key Patterns Used

| Feature | Pattern |
|---|---|
| Ring clock | `Canvas` with `arc()` for seconds/minutes arcs |
| Hero typography | `font.pixelSize: isTiming ? 76 : 72` + `Behavior on font.pixelSize` |
| Spring motion | `ChiTheme.motion.spring.fast.spatial` tokens |
| Morphing nav | `Behavior on x` with `Easing.BezierSpline` |
| Lap list | `ListItem` with `leadingIcon`, `secondaryText` |
| Theme toggling | `ChiTheme.toggleDarkMode()` calls from ChiApplicationWindow |

## Motion Tokens Used

All motion comes from `ChiTheme.motion`:

```qml
ChiTheme.motion.spring.fast.spatial.duration    // 350ms
ChiTheme.motion.spring.fast.spatial.curve       // [0.42, 1.67, 0.21, 0.90]
ChiTheme.motion.spring.medium.spatial.duration  // 500ms
```

The `Behavior on x` for the tab indicator uses a custom Emphasized Decelerate curve `[0.05, 0.7, 0.1, 1.0]` which maps to M3's `emphasizedDecelerate` easing.

## License

Same as Chi — open source, free for all users.
