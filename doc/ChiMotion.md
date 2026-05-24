# ChiMotion

Singleton that provides all motion and animation tokens used throughout Chi. Defines spring physics, easing curves, and duration constants per Material 3 Motion specifications.

## Structure

**spring** — Spring physics configuration.
  - **fast** — Quick bouncy animations (350ms damping 0.9, 150ms effects)
  - **medium** — Standard spring (500ms damping 0.9, 200ms effects)
  - **slow** — Deliberate spring (650ms damping 0.9, 300ms effects)

**spatial** — Spring values for spatial transforms (scale, translate, rotate).

**effects** — Spring values for color, shape, opacity effects.

**easing** — Bezier curve arrays for custom easing:
  - **emphasized**: Primary and pair transforms (M3 entry/exit animations)
  - **emphasizedAccelerate / emphasizedDecelerate**: Shorthand for acceleration halves
  - **standard**: Container shape and elevation
  - **standardAccelerate / standardDecelerate**: Shorthand for standard halves
  - **legacy / legacyAccelerate / legacyDecelerate**: Backwards-compatible curves
  - **linear**: No easing

**duration** — Timing constants in milliseconds:
  - short1: 50, short2: 100, short3: 150, short4: 200
  - medium1: 250, medium2: 300, medium3: 350, medium4: 400
  - long1: 450, long2: 500, long3: 550, long4: 600
  - extraLong1: 700, extraLong2: 800, extraLong3: 900, extraLong4: 1000

**stateLayer** — Opacity values for hover, focus, press, drag, and disabled states.

**shapeMorph** — Duration and corner radius values for shape-changing animations.

**elevation** — Elevation animation timing.

**colorChange** — Color transition timing.

**page** — Page navigation: enter/exit durations, slide distance (30px), and scale out effect (0.96).

## Usage

Components reference ChiMotion internally. Do not instantiate. Read tokens via `ChiTheme.motion`.
