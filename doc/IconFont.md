# IconFont

Singleton that loads and provides the Material Symbols font. Components reference this through the `fontFamily` property — never instantiated directly.

## Properties

| Property | Type | Default | Description |
|---|---|---|---|
| family | readonly string | "Material Symbols Rounded" | The loaded font family name |
| ready | readonly bool | true when the font loader has finished loading |

## Usage

IconFont is used automatically by components that accept the `iconName` property (e.g. `iconName: "settings"`). The font is embedded in the binary resource system and loaded at startup.
