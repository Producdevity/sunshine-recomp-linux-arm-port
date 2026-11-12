#!/bin/bash
# Builds the PortMaster port folder and an installable sunshine.zip from an aarch64 build
# directory (the translating `sunshine` target).
# PROGRAM_LIST, a Starlet program list recorded over the game's routes, ships as
# sunshine/programs.list; the first launch builds those shaders behind a progress bar.
# GC_RECOMP_VERSION names gc-recomp in VERSION when its source is not a git checkout.
# Usage: [PROGRAM_LIST=FILE] tools/package-portmaster.sh BUILD_DIR OUTPUT_DIR
set -euo pipefail

if [ $# -ne 2 ]; then
    echo "usage: [PROGRAM_LIST=FILE] $0 BUILD_DIR OUTPUT_DIR" >&2
    exit 2
fi
if [ -n "${PROGRAM_LIST:-}" ] && ! head -1 "$PROGRAM_LIST" | grep -qx '# starlet program list 1'; then
    echo "PROGRAM_LIST is not a Starlet program list: $PROGRAM_LIST" >&2
    exit 1
fi
root=$(cd "$(dirname "$0")/.." && pwd)
build=$(cd "$1" && pwd)
mkdir -p "$2"
out=$(cd "$2" && pwd)
[ -f "$build/sunshine" ] || { echo "missing $build/sunshine; build the sunshine target" >&2; exit 1; }
strip=$(sed -n 's/^CMAKE_STRIP:FILEPATH=//p' "$build/CMakeCache.txt")
recomp=$(sed -n 's/^GC_RECOMP_DIR:PATH=//p' "$build/CMakeCache.txt")
port="$out/sunshine"

rm -rf "$port" "$out/sunshine.zip"
# The catalogue images are device captures of the game, kept out of the repository.
for image in screenshot.jpg cover.jpg; do
    [ -f "$root/packaging/ports/sunshine/$image" ] || { echo "missing packaging/ports/sunshine/$image (640x480 JPEG from a device capture)" >&2; exit 1; }
done
cp -R "$root/packaging/ports/sunshine" "$port"
mkdir "$port/sunshine" "$port/sunshine/gamefiles"
"$strip" -o "$port/sunshine/sunshine.aarch64" "$build/sunshine"
mkdir "$port/sunshine/licenses"
starlet=$(sed -n 's/^GC_STARLET_DIR:PATH=//p' "$build/CMakeCache.txt")
cp "$root/LICENSE" "$port/sunshine/licenses/LICENSE.sunshine.txt"
cp "$recomp/LICENSE" "$port/sunshine/licenses/LICENSE.gc-recomp.txt"
cp "$starlet/LICENSE" "$port/sunshine/licenses/LICENSE.starlet.txt"
cp "$starlet/third_party/zstd/LICENSE" "$port/sunshine/licenses/LICENSE.zstd.txt"
cp "$root/config/LICENSE.doldecomp-sms.txt" "$port/sunshine/licenses/LICENSE.doldecomp-sms.txt"
[ -z "${PROGRAM_LIST:-}" ] || cp "$PROGRAM_LIST" "$port/sunshine/programs.list"
cp "$root/config/GMSE01.symbols.txt" "$root/config/GMSE01.cfg" "$port/sunshine/"
echo "Place your disc image (.iso, .gcm or .rvz) in this folder." > "$port/sunshine/gamefiles/README.txt"
# The commits the package was built from, so a log names it.
echo "sunshine $(git -C "$root" rev-parse --short HEAD)$(git -C "$root" diff --quiet HEAD || echo +), gc-recomp ${GC_RECOMP_VERSION:-$(git -C "$recomp" rev-parse --short HEAD)$(git -C "$recomp" diff --quiet HEAD || echo +)}" > "$port/sunshine/VERSION"

# PortMaster's release zips keep the launcher at the root and move the catalogue
# files and images into the port folder, with the README renamed after the port.
stage=$(mktemp -d)
trap 'rm -rf "$stage"' EXIT
cp "$port/Super Mario Sunshine.sh" "$stage/"
cp -R "$port/sunshine" "$stage/sunshine"
cp "$port/port.json" "$port/gameinfo.xml" "$port/screenshot.jpg" "$port/cover.jpg" "$stage/sunshine/"
cp "$port/README.md" "$stage/sunshine/sunshine.md"
(cd "$stage" && COPYFILE_DISABLE=1 zip -qrX9 "$out/sunshine.zip" "Super Mario Sunshine.sh" sunshine)
echo "$port"
echo "$out/sunshine.zip"
