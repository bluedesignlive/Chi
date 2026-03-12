#!/bin/bash
# ═══════════════════════════════════════════════════════════════
#  Chi — Install Script
#  Bulletproof: cleans stale caches, detects build tools, handles
#  in-source pollution, and never leaves broken state.
# ═══════════════════════════════════════════════════════════════

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

info()  { echo -e "${CYAN}[Chi]${NC} $1"; }
ok()    { echo -e "${GREEN}[Chi]${NC} $1"; }
warn()  { echo -e "${YELLOW}[Chi]${NC} $1"; }
fail()  { echo -e "${RED}[Chi]${NC} $1"; exit 1; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR" || fail "Cannot cd to project root"

echo ""
echo -e "${BOLD}═══════════════════════════════════════${NC}"
echo -e "${BOLD}  Chi — Material 3 for Qt/QML          ${NC}"
echo -e "${BOLD}═══════════════════════════════════════${NC}"
echo ""

# ── 1. Nuke in-source cmake pollution ────────────────────────
#    This is the #1 cause of "could not load cache" errors.
#    If someone ran cmake . in the source root, we fix it silently.

POLLUTED=0
for JUNK in CMakeCache.txt CMakeFiles cmake_install.cmake Makefile install_manifest.txt CTestTestfile.cmake; do
    if [ -e "$SCRIPT_DIR/$JUNK" ]; then
        POLLUTED=1
        break
    fi
done

if [ "$POLLUTED" -eq 1 ]; then
    warn "Detected in-source CMake artifacts (stale cache). Cleaning..."
    rm -rf "$SCRIPT_DIR/CMakeCache.txt" \
           "$SCRIPT_DIR/CMakeFiles" \
           "$SCRIPT_DIR/cmake_install.cmake" \
           "$SCRIPT_DIR/Makefile" \
           "$SCRIPT_DIR/install_manifest.txt" \
           "$SCRIPT_DIR/CTestTestfile.cmake" \
           "$SCRIPT_DIR/CMakeLists.txt.user" \
           "$SCRIPT_DIR"/*.cbp 2>/dev/null
    ok "In-source mess cleaned."
fi

# ── 2. Check dependencies ────────────────────────────────────
info "Checking dependencies..."

HAS_CMAKE=0
HAS_NINJA=0
HAS_MAKE=0

command -v cmake >/dev/null 2>&1 && HAS_CMAKE=1
command -v ninja >/dev/null 2>&1 && HAS_NINJA=1
command -v make  >/dev/null 2>&1 && HAS_MAKE=1

if [ "$HAS_CMAKE" -eq 0 ]; then
    fail "cmake is required but not found.

  On Fedora:   sudo dnf install cmake
  On Ubuntu:   sudo apt install cmake
  On Arch:     sudo pacman -S cmake"
fi

if [ "$HAS_NINJA" -eq 0 ] && [ "$HAS_MAKE" -eq 0 ]; then
    fail "Need either ninja or make as a build backend.

  On Fedora:   sudo dnf install ninja-build   (or make)
  On Ubuntu:   sudo apt install ninja-build    (or make)
  On Arch:     sudo pacman -S ninja            (or make)"
fi

# Pick the best available generator
if [ "$HAS_NINJA" -eq 1 ]; then
    GENERATOR="Ninja"
    BUILD_CMD="ninja"
else
    GENERATOR="Unix Makefiles"
    BUILD_CMD="make -j$(nproc)"
fi

# Check for Qt6
QMAKE_BIN=""
for TRY in qmake6 qmake; do
    if command -v "$TRY" >/dev/null 2>&1; then
        QMAKE_BIN="$TRY"
        break
    fi
done

if [ -z "$QMAKE_BIN" ]; then
    fail "Qt6 qmake not found.

  On Fedora:   sudo dnf install qt6-qtbase-devel qt6-qtdeclarative-devel
  On Ubuntu:   sudo apt install qt6-base-dev qt6-declarative-dev
  On Arch:     sudo pacman -S qt6-base qt6-declarative"
fi

# Verify Qt6Qml is available to cmake
if ! pkg-config --exists Qt6Qml 2>/dev/null; then
    if [ ! -f /usr/lib64/cmake/Qt6Qml/Qt6QmlConfig.cmake ] && \
       [ ! -f /usr/lib/cmake/Qt6Qml/Qt6QmlConfig.cmake ] && \
       [ ! -f /usr/lib/x86_64-linux-gnu/cmake/Qt6Qml/Qt6QmlConfig.cmake ]; then
        fail "Qt6 QML development package not found.

  On Fedora:   sudo dnf install qt6-qtdeclarative-devel
  On Ubuntu:   sudo apt install qt6-declarative-dev
  On Arch:     sudo pacman -S qt6-declarative"
    fi
fi

ok "All dependencies found. (generator: $GENERATOR)"

# ── 3. Detect install path ────────────────────────────────────
QML_DIR=$($QMAKE_BIN -query QT_INSTALL_QML 2>/dev/null)
if [ -z "$QML_DIR" ]; then
    fail "Could not detect Qt QML path."
fi

info "Qt QML path: ${BOLD}$QML_DIR${NC}"
info "Chi will install to: ${BOLD}$QML_DIR/Chi${NC}"
echo ""

NEED_SUDO=""
if [ ! -w "$QML_DIR" ]; then
    NEED_SUDO="sudo"
    warn "Install path requires root. Will use sudo."
fi

# ── 4. Confirm ────────────────────────────────────────────────
read -rp "$(echo -e "${CYAN}[Chi]${NC} Proceed with install? [Y/n] ")" REPLY
REPLY=${REPLY:-Y}
if [[ ! "$REPLY" =~ ^[Yy]$ ]]; then
    info "Aborted."
    exit 0
fi

# ── 5. Prepare build directory ────────────────────────────────
BUILD_DIR="$SCRIPT_DIR/build"

# If build/ exists but is broken (wrong generator, stale cache), nuke it
if [ -d "$BUILD_DIR" ]; then
    # Check if the cache points to a different source dir or wrong generator
    NEEDS_CLEAN=0

    if [ -f "$BUILD_DIR/CMakeCache.txt" ]; then
        CACHED_SRC=$(grep 'CMAKE_HOME_DIRECTORY:INTERNAL' "$BUILD_DIR/CMakeCache.txt" 2>/dev/null | cut -d= -f2)
        CACHED_GEN=$(grep 'CMAKE_GENERATOR:INTERNAL' "$BUILD_DIR/CMakeCache.txt" 2>/dev/null | cut -d= -f2)

        if [ -n "$CACHED_SRC" ] && [ "$CACHED_SRC" != "$SCRIPT_DIR" ]; then
            NEEDS_CLEAN=1
            warn "Build cache points to wrong source: $CACHED_SRC"
        fi

        if [ -n "$CACHED_GEN" ] && [ "$CACHED_GEN" != "$GENERATOR" ]; then
            NEEDS_CLEAN=1
            warn "Build cache uses different generator: $CACHED_GEN (want: $GENERATOR)"
        fi
    else
        # No cache at all in build/ — stale directory
        NEEDS_CLEAN=1
    fi

    if [ "$NEEDS_CLEAN" -eq 1 ]; then
        warn "Cleaning stale build directory..."
        rm -rf "$BUILD_DIR"
    fi
fi

mkdir -p "$BUILD_DIR"

# ── 6. Configure ──────────────────────────────────────────────
info "Configuring with $GENERATOR..."
cd "$BUILD_DIR"

cmake "$SCRIPT_DIR" \
    -G "$GENERATOR" \
    -DCMAKE_BUILD_TYPE=Release \
    || fail "CMake configure failed."

# ── 7. Build ──────────────────────────────────────────────────
info "Building..."
cmake --build . --parallel "$(nproc)" \
    || fail "Build failed."

ok "Build successful."

# ── 8. Install ────────────────────────────────────────────────
info "Installing..."
$NEED_SUDO cmake --install . \
    || fail "Install failed. Check permissions."

ok "Chi installed to $QML_DIR/Chi"

# ── 9. Default config ────────────────────────────────────────
CHI_CONFIG="$HOME/.config/chi"
if [ ! -f "$CHI_CONFIG/theme.json" ]; then
    mkdir -p "$CHI_CONFIG"
    cat << 'CONF' > "$CHI_CONFIG/theme.json"
{
    "darkMode": true,
    "primary": "#386a20"
}
CONF
    ok "Default config created: $CHI_CONFIG/theme.json"
else
    ok "Existing config preserved: $CHI_CONFIG/theme.json"
fi

# ── 10. Migrate old smartui-beta config if present ────────────
OLD_CONFIG="$HOME/.config/smartui-beta"
if [ -d "$OLD_CONFIG" ] && [ -f "$OLD_CONFIG/theme.json" ] && [ ! -f "$CHI_CONFIG/.migrated" ]; then
    info "Found old smartui-beta config. Migrating..."
    cp "$OLD_CONFIG/theme.json" "$CHI_CONFIG/theme.json"
    touch "$CHI_CONFIG/.migrated"
    ok "Theme migrated from smartui-beta → chi"
fi

# ── Done ──────────────────────────────────────────────────────
cd "$SCRIPT_DIR"

echo ""
echo -e "${GREEN}${BOLD}═══════════════════════════════════════${NC}"
echo -e "${GREEN}${BOLD}  Chi installed successfully!           ${NC}"
echo -e "${GREEN}${BOLD}═══════════════════════════════════════${NC}"
echo ""
echo -e "  ${BOLD}Usage in QML:${NC}"
echo "    import Chi 1.0"
echo ""
echo -e "  ${BOLD}Change theme from terminal:${NC}"
echo "    echo '{\"darkMode\": false, \"primary\": \"#6750a4\"}' > ~/.config/chi/theme.json"
echo ""
echo -e "  ${BOLD}Uninstall:${NC}"
echo "    ./uninstall.sh"
echo ""
