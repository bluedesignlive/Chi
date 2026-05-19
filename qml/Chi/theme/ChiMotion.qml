pragma Singleton
import QtQuick

QtObject {
    id: motion

    // ═══════════════════════════════════════════════════════════════
    //  GLOBAL TOGGLE
    // ═══════════════════════════════════════════════════════════════

    property bool animationsEnabled: true

    // ═══════════════════════════════════════════════════════════════
    //  SCHEME ("expressive" | "standard")
    // ═══════════════════════════════════════════════════════════════

    property string scheme: "expressive"

    // ═══════════════════════════════════════════════════════════════
    //  SPRING TOKENS
    //
    //  Each spring has:
    //    damping, stiffness  — for physics-based platforms
    //    curve[]             — cubic-bezier fallback for Qt/web
    //    duration            — suggested duration for NumberAnimation
    //
    //  Fast    → small components (buttons, switches, tooltips)
    //  Default → medium elements (sheets, nav rail, bottom bars)
    //  Slow    → full-screen transitions
    //
    //  Spatial → position, scale, rotation, corner radius (overshoot OK)
    //  Effects → opacity, color (no overshoot)
    // ═══════════════════════════════════════════════════════════════

    readonly property QtObject spring: QtObject {
        readonly property QtObject fast: QtObject {
            // spring(damping=0.9, stiffness=1400)
            readonly property QtObject spatial: QtObject {
                readonly property real damping: 0.9
                readonly property real stiffness: 1400
                readonly property var curve: [0.42, 1.67, 0.21, 0.90]
                readonly property int duration: 350
            }
            // spring(damping=1, stiffness=3800)
            readonly property QtObject effects: QtObject {
                readonly property real damping: 1
                readonly property real stiffness: 3800
                readonly property var curve: [0.31, 0.94, 0.34, 1.00]
                readonly property int duration: 150
            }
        }

        readonly property QtObject medium: QtObject {
            // spring(damping=0.9, stiffness=700)
            readonly property QtObject spatial: QtObject {
                readonly property real damping: 0.9
                readonly property real stiffness: 700
                readonly property var curve: [0.38, 1.21, 0.22, 1.00]
                readonly property int duration: 500
            }
            // spring(damping=1, stiffness=1600)
            readonly property QtObject effects: QtObject {
                readonly property real damping: 1
                readonly property real stiffness: 1600
                readonly property var curve: [0.34, 0.80, 0.34, 1.00]
                readonly property int duration: 200
            }
        }

        readonly property QtObject slow: QtObject {
            // spring(damping=0.9, stiffness=300)
            readonly property QtObject spatial: QtObject {
                readonly property real damping: 0.9
                readonly property real stiffness: 300
                readonly property var curve: [0.39, 1.29, 0.35, 0.98]
                readonly property int duration: 650
            }
            // spring(damping=1, stiffness=800)
            readonly property QtObject effects: QtObject {
                readonly property real damping: 1
                readonly property real stiffness: 800
                readonly property var curve: [0.34, 0.88, 0.34, 1.00]
                readonly property int duration: 300
            }
        }
    }

    // ═══════════════════════════════════════════════════════════════
    //  EASING TOKENS  (cubic-bezier arrays)
    // ═══════════════════════════════════════════════════════════════

    readonly property QtObject easing: QtObject {
        readonly property var emphasized: [0.05, 0, 0.133333, 0.06, 0.166666, 0.4, 0.208333, 0.82, 0.25, 1, 1, 1]
        readonly property var emphasizedAccelerate: [0.3, 0.0, 0.8, 0.15]
        readonly property var emphasizedDecelerate: [0.05, 0.7, 0.1, 1.0]
        readonly property var standard: [0.2, 0.0, 0.0, 1.0]
        readonly property var standardAccelerate: [0.3, 0.0, 1.0, 1.0]
        readonly property var standardDecelerate: [0.0, 0.0, 0.0, 1.0]
        readonly property var legacy: [0.4, 0.0, 0.2, 1.0]
        readonly property var legacyAccelerate: [0.4, 0.0, 1.0, 1.0]
        readonly property var legacyDecelerate: [0.0, 0.0, 0.2, 1.0]
        readonly property var linear: [0.0, 0.0, 1.0, 1.0]
    }

    // ═══════════════════════════════════════════════════════════════
    //  DURATION TOKENS  (ms)
    // ═══════════════════════════════════════════════════════════════

    readonly property QtObject duration: QtObject {
        readonly property int short1: 50
        readonly property int short2: 100
        readonly property int short3: 150
        readonly property int short4: 200
        readonly property int medium1: 250
        readonly property int medium2: 300
        readonly property int medium3: 350
        readonly property int medium4: 400
        readonly property int long1: 450
        readonly property int long2: 500
        readonly property int long3: 550
        readonly property int long4: 600
        readonly property int extraLong1: 700
        readonly property int extraLong2: 800
        readonly property int extraLong3: 900
        readonly property int extraLong4: 1000
    }

    // ═══════════════════════════════════════════════════════════════
    //  STATE LAYER OPACITY  (md.sys.state.*)
    // ═══════════════════════════════════════════════════════════════

    readonly property QtObject stateLayer: QtObject {
        readonly property real hover: 0.08
        readonly property real focus: 0.10
        readonly property real pressed: 0.10
        readonly property real dragged: 0.16
        readonly property real disabled: 0.38
    }

    // ═══════════════════════════════════════════════════════════════
    //  ANIMATION PRESETS
    //
    //  Each preset provides the properties needed for that transition.
    //  Components use:
    //    NumberAnimation {
    //        duration: motion.entry.duration
    //        easing.type: Easing.Bezier
    //        easing.bezierCurve: motion.entry.curve
    //    }
    // ═══════════════════════════════════════════════════════════════

    // ── Entry (hidden → visible): small elements ──
    // Uses emphasizedDecelerate for smooth entrance — opacity-safe
    readonly property QtObject entry: QtObject {
        readonly property int duration: motion.duration.short3
        readonly property var curve: motion.easing.emphasizedDecelerate
        readonly property real scaleFrom: 0.92
        readonly property real scaleTo: 1.0
        readonly property real translateY: 6
    }

    // ── Entry Bouncy (hidden → visible): spatial-only with M3 Expressive overshoot
    // Uses 12-value multi-segment emphasized curve for extra bounce on scale/position
    // Do NOT use for opacity — the overshoot causes opacity > 1 flicker
    readonly property QtObject entryBouncy: QtObject {
        readonly property int duration: motion.duration.medium1
        readonly property var curve: motion.easing.emphasized
        readonly property real scaleFrom: 0.88
        readonly property real scaleTo: 1.0
        readonly property real translateY: 8
    }

    // ── Exit (visible → hidden): small elements ──
    // Uses emphasizedAccelerate for fast departure — no bounce needed on exit
    readonly property QtObject exit: QtObject {
        readonly property int duration: motion.duration.short2
        readonly property var curve: motion.easing.emphasizedAccelerate
        readonly property real scaleTo: 0.92
        readonly property real scaleFrom: 1.0
        readonly property real translateY: -6
    }

    // ── Exit Bouncy (visible → hidden): spatial-only with M3 Expressive overshoot
    // Uses 12-value multi-segment emphasized curve for expressive exit
    readonly property QtObject exitBouncy: QtObject {
        readonly property int duration: motion.duration.short3
        readonly property var curve: motion.easing.emphasized
        readonly property real scaleTo: 0.85
        readonly property real scaleFrom: 1.0
        readonly property real translateY: -8
    }

    // ── Press (touch down) ──
    readonly property QtObject press: QtObject {
        readonly property int duration: motion.duration.short1
        readonly property var curve: motion.easing.emphasizedAccelerate
        readonly property real scaleTo: 0.97
        readonly property real scaleFrom: 1.0
    }

    // ── Release (touch up) ──
    readonly property QtObject release: QtObject {
        readonly property int duration: motion.duration.short4
        readonly property var curve: motion.easing.emphasizedDecelerate
        readonly property real scaleFrom: 0.97
        readonly property real scaleTo: 1.0
    }

    // ── Hover state layer transition ──
    readonly property QtObject hoverState: QtObject {
        readonly property int duration: motion.duration.short2
        readonly property var curve: motion.easing.standard
    }

    // ── Focus state layer transition ──
    readonly property QtObject focusState: QtObject {
        readonly property int duration: motion.duration.short2
        readonly property var curve: motion.easing.standard
    }

    // ── Shape morph (corner radius) ──
    readonly property QtObject shapeMorph: QtObject {
        readonly property int duration: motion.spring.fast.spatial.duration
        readonly property var curve: motion.spring.fast.spatial.curve
        readonly property real pressedRadius: 8
        readonly property real restingRadius: 20
    }

    // ── Elevation change ──
    readonly property QtObject elevation: QtObject {
        readonly property int duration: motion.duration.short2
        readonly property var curve: motion.easing.standard
    }

    // ── Color change ──
    readonly property QtObject colorChange: QtObject {
        readonly property int duration: motion.duration.short3
        readonly property var curve: motion.easing.standard
    }

    // ── Page transition ──
    readonly property QtObject page: QtObject {
        readonly property int enterDuration: motion.duration.short4
        readonly property int exitDuration: motion.duration.short2
        readonly property var enterCurve: motion.easing.emphasizedDecelerate
        readonly property var exitCurve: motion.easing.emphasizedAccelerate
        readonly property real slideDistance: 30
        readonly property real scaleOut: 0.96
    }

    // ═══════════════════════════════════════════════════════════════
    //  BACKWARD COMPATIBILITY  (old Theme.ChiTheme.motion.*)
    //
    //  These match the property names that existing components use.
    //  New components should use the tokens/presets above.
    // ═══════════════════════════════════════════════════════════════

    readonly property int durationFast: motion.duration.short2
    readonly property int durationMedium: motion.duration.short4
    readonly property int durationSlow: motion.duration.medium3
    readonly property int durationExpressive: motion.duration.long2

    readonly property int easeStandard: Easing.OutCubic
    readonly property int easeEmphasized: Easing.OutQuart
    readonly property int easeBounce: Easing.OutBounce
    readonly property int easeElastic: Easing.OutElastic
    readonly property int easeBack: Easing.OutBack

    readonly property int pageExitDuration: motion.page.exitDuration
    readonly property int pageEnterDuration: motion.page.enterDuration
    readonly property int pageExitEasing: Easing.InQuart
    readonly property int pageEnterEasing: Easing.OutQuart
    readonly property real pageSlideDistance: motion.page.slideDistance
    readonly property real pageScaleOut: motion.page.scaleOut
}
