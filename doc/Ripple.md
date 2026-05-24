# Ripple

Circular press ripple effect used by interactive components. Visual feedback for pointer press events, inspired by Material Design.

## Properties

| Property | Type | Default | Description |
|---|---|---|---|
| color | color | "white" | Color of the ripple effect |
| radius | real | 0 | Maximum radius. 0 = auto-calculate from parent size. |
| enabled | bool | true | Whether the ripple is active |
| startX | real | width / 2 | X position where the ripple originates |
| startY | real | height / 2 | Y position where the ripple originates |

## Methods

**addRipple(mx, my)** — Start a ripple at the given coordinates.

**removeRipple()** — Force-remove all active ripples.

## Usage

Components like Card and Button use Ripple internally. Rarely instantiates directly.
