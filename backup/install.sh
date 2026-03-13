#!/bin/bash
# ═══════════════════════════════════════════════════════════════
#  Chi — Install Script
#  Builds and installs the Chi QML plugin to your Qt6 QML path.
# ═══════════════════════════════════════════════════════════════

set -e

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

echo ""
echo -e "${BOLD}═══════════════════════════════════════${NC}"
echo -e "${BOLD}  Chi — Material 3 for Qt/QML          ${NC}"
echo -e "${BOLD}═══════════════════════════════════════${NC}"
echo ""

# ── 1. Check dependencies ────────────────────────────────────
info "Checking dependencies..."

MISSING=()
command -v cmake  >/dev/null 2>&1 || MISSING+=("cmake")
command -v make   >/dev/null 2>&1 || MISSING+=("make (or ninja)")
command -v qmake6 >/dev/null 2>&1 || {
    # Try Qt6's qmake under different names
    command -v qmake >/dev/null 2>&1 || MISSING+=("qt6-qtdeclarative-devel (qmake6)")
}

# Check for Qt6 QML dev headers
if ! pkg-config --exists Qt6Qml 2>/dev/null; then
    if [ ! -f /usr/lib64/cmake/Qt6Qml/Qt6QmlConfig.cmake ] && \
       [ ! -f /usr/lib/cmake/Qt6Qml/Qt6QmlConfig.cmake ]; then
        MISSING+=("qt6-qtdeclarative-devel")
    fi
fi

if [ ${#MISSING[@]} -ne 0 ]; then
    fail "Missing packages: ${MISSING[*]}

  On Fedora:
    sudo dnf install cmake gcc-c++ qt6-qtbase-devel qt6-qtdeclarative-devel

  On Ubuntu/Debian:
    sudo apt install cmake g++ qt6-base-dev qt6-declarative-dev

  On Arch:
    sudo pacman -S cmake qt6-base qt6-declarative"
fi

ok "All dependencies found."

# ── 2. Detect Qt QML install path ────────────────────────────
QMAKE_BIN=$(command -v qmake6 2>/dev/null || command -v qmake 2>/dev/null)
QML_DIR=$($QMAKE_BIN -query QT_INSTALL_QML 2>/dev/null)

if [ -z "$QML_DIR" ]; then
    fail "Could not detect Qt QML path. Is Qt6 properly installed?"
fi

info "Qt QML path: ${BOLD}$QML_DIR${NC}"
info "Chi will install to: ${BOLD}$QML_DIR/Chi${NC}"
echo ""

# ── 3. Ask for confirmation ──────────────────────────────────
NEED_SUDO=""
if [ ! -w "$QML_DIR" ]; then
    NEED_SUDO="sudo"
    warn "Install path requires root. Will use sudo."
fi

read -rp "$(echo -e "${CYAN}[Chi]${NC} Proceed with install? [Y/n] ")" REPLY
REPLY=${REPLY:-Y}
if [[ ! "$REPLY" =~ ^[Yy]$ ]]; then
    info "Aborted."
    exit 0
fi

# ── 4. Build ──────────────────────────────────────────────────
BUILD_DIR="build"
info "Building in ./$BUILD_DIR ..."

mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

cmake .. -DCMAKE_BUILD_TYPE=Release
cmake --build . --parallel "$(nproc)"

ok "Build successful."

# ── 5. Install ────────────────────────────────────────────────
info "Installing..."
$NEED_SUDO cmake --install .

ok "Chi installed to $QML_DIR/Chi"

# ── 6. Create default config if missing ──────────────────────
CHI_CONFIG="$HOME/.config/chi"
if [ ! -f "$CHI_CONFIG/theme.json" ]; then
    mkdir -p "$CHI_CONFIG"
    echo '{"darkMode": true, "primary": "#386a20"}' > "$CHI_CONFIG/theme.json"
    ok "Default config created: $CHI_CONFIG/theme.json"
else
    ok "Existing config preserved: $CHI_CONFIG/theme.json"
fi

# ── 7. Done ───────────────────────────────────────────────────
echo ""
echo -e "${GREEN}${BOLD}═══════════════════════════════════════${NC}"
echo -e "${GREEN}${BOLD}  Chi installed successfully!           ${NC}"
echo -e "${GREEN}${BOLD}═══════════════════════════════════════${NC}"
echo ""
echo -e "  ${BOLD}Usage in QML:${NC}"
echo '    import Chi 1.0'
echo ""
echo -e "  ${BOLD}Change theme from terminal:${NC}"
echo "    echo '{\"darkMode\": false, \"primary\": \"#6750a4\"}' > ~/.config/chi/theme.json"
echo ""
echo -e "  ${BOLD}Uninstall:${NC}"
echo "    ./uninstall.sh"
echo ""
