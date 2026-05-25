# ChiCounter

A minimal counter app built with Chi components. Single QML file, no C++ logic.

Demonstrates:
- `ChiApplicationWindow`
- `Button` (enabled/disabled states, flat variant)
- Reading `ChiTheme.colors.primary` for text styling
- QML property bindings

## Build

```bash
cd examples/ChiCounter
cmake -B build
cmake --build build
./build/chicounter
```

Requires Qt 6 and Chi installed in the QML import path.
