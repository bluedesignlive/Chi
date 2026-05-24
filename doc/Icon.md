# Icon

Renders icons from three sources: Material Symbols (via font), SVG/PNG image files, and Unicode character fallback. Used throughout Chi for consistent icon rendering.

## Properties

| Property | Type | Default | Description |
|---|---|---|---|
| source | string | "" | The icon source — can be a Material Symbol name, file path (SVG, PNG), or Unicode character |
| size | real | 24 | Icon size in pixels |
| color | color | onSurface | Color for the icon |
| filled | bool | false | Use the filled weight variant of Material Symbols |
| weight | int | 400 | Font weight for Material Symbols (100–700) |
| grade | real | 0 | Grade adjustment for Material Symbols (-25 to 200) |
| fallback | string | "" | Fallback icon name if the primary source fails to load |

## Readonly Properties

| Property | Type | Description |
|---|---|---|
| isImageSource | bool | True when source is an image file path |
| isMaterialIcon | bool | True when source is a Material Symbol name |
| isUnicodeIcon | bool | True when source is a Unicode character |

## Usage Example

```qml
// Material Symbol
Icon {
    source: "settings"
    size: 48
    color: ChiTheme.colors.primary
}

// SVG file
Icon {
    source: "qrc:/assets/settings.svg"
    size: 24
    color: "red"
}
```
