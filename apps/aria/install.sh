#!/bin/bash
set -e

RED='\033[0;31m'; GREEN='\033[0;32m'; CYAN='\033[0;36m'; BOLD='\033[1m'; NC='\033[0m'
info()  { echo -e "${CYAN}[Aria]${NC} $1"; }
ok()    { echo -e "${GREEN}[Aria]${NC} $1"; }
fail()  { echo -e "${RED}[Aria]${NC} $1"; exit 1; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo ""
echo -e "${BOLD}  Aria — Audio Player${NC}"
echo ""

# Check Chi is installed
QMAKE_BIN=$(command -v qmake6 2>/dev/null || command -v qmake 2>/dev/null)
QML_DIR=$($QMAKE_BIN -query QT_INSTALL_QML 2>/dev/null)
[ ! -d "$QML_DIR/Chi" ] && fail "Chi library not installed. Run ./install.sh from the chi root first."
ok "Chi library found."

# Check dependencies
command -v cmake >/dev/null 2>&1 || fail "cmake not found"
HAS_NINJA=0; command -v ninja >/dev/null 2>&1 && HAS_NINJA=1
GENERATOR="Unix Makefiles"; [ "$HAS_NINJA" -eq 1 ] && GENERATOR="Ninja"

# Clean stale in-source cmake artifacts
rm -rf "$SCRIPT_DIR/CMakeCache.txt" "$SCRIPT_DIR/CMakeFiles" "$SCRIPT_DIR/cmake_install.cmake" "$SCRIPT_DIR/Makefile" 2>/dev/null

NEED_SUDO=""
[ ! -w "/usr/local/bin" ] && NEED_SUDO="sudo"

BUILD_DIR="$SCRIPT_DIR/build"
if [ -d "$BUILD_DIR/CMakeCache.txt" ]; then
    CACHED_SRC=$(grep 'CMAKE_HOME_DIRECTORY:INTERNAL' "$BUILD_DIR/CMakeCache.txt" 2>/dev/null | cut -d= -f2)
    [ -n "$CACHED_SRC" ] && [ "$CACHED_SRC" != "$SCRIPT_DIR" ] && rm -rf "$BUILD_DIR"
fi

mkdir -p "$BUILD_DIR" && cd "$BUILD_DIR"

info "Configuring ($GENERATOR)..."
cmake "$SCRIPT_DIR" -G "$GENERATOR" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr

info "Building..."
cmake --build . --parallel "$(nproc)"

info "Installing..."
$NEED_SUDO cmake --install .

$NEED_SUDO update-desktop-database /usr/share/applications 2>/dev/null || true
$NEED_SUDO gtk-update-icon-cache /usr/share/icons/hicolor 2>/dev/null || true

echo ""
ok "Aria installed! Run with: aria"
echo ""
