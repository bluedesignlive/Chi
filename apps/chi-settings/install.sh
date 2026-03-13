#!/bin/bash
set -e

cd "$(dirname "$0")"
rm -rf build
mkdir build && cd build

cmake .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr

make -j$(nproc)
sudo make install

echo "[chi-settings] Installed."
