# Contributing

Thanks for wanting to make Chi better.

## How to add a component

Chi follows a fixed pattern. Read it before writing code:

1. Put your component in `qml/Chi/ui/<category>/`
2. Read colors from `ChiTheme.colors` — never hardcode
3. Read durations from `ChiMotion` — never hardcode
4. Read elevation from `ChiElevation` — never hardcode
5. Add the component to `qmldir`
6. Write a doc file in `doc/<ComponentName>.md`
7. Add it to `MVP-COMPONENTS.md` if it's core

## Behavioral contracts

Every component ships with a behavioral contract. If it's a button, it clicks. If it's a slider, it drags. Visual polish can come later — the interaction must work first. See `MVP-COMPONENTS.md` for the current spec.

## Code style

- No comments unless necessary
- Match the existing indentation and naming
- Use `iconName` (Material Symbol name) over raw icon paths
- Use `enabled` for disabled states, not `activeFocusOnTab`
- Read `readonly property var colors: ChiTheme.colors` — do not cache

## Pull requests

Keep PRs focused. One feature or fix per PR. Harsh feedback is welcome — don't take it personally.

## Reporting issues

Use the issue templates. Bug reports need a minimal reproduction. Feature requests need a use case.
