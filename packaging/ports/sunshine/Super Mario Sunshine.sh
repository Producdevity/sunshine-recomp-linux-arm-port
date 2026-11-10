#!/bin/bash

XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}

if [ -d "/opt/system/Tools/PortMaster/" ]; then
  controlfolder="/opt/system/Tools/PortMaster"
elif [ -d "/opt/tools/PortMaster/" ]; then
  controlfolder="/opt/tools/PortMaster"
elif [ -d "$XDG_DATA_HOME/PortMaster/" ]; then
  controlfolder="$XDG_DATA_HOME/PortMaster"
else
  controlfolder="/roms/ports/PortMaster"
fi

source $controlfolder/control.txt
[ -f "${controlfolder}/mod_${CFW_NAME}.txt" ] && source "${controlfolder}/mod_${CFW_NAME}.txt"
get_controls

GAMEDIR="/$directory/ports/sunshine"
cd "$GAMEDIR"
> "$GAMEDIR/log.txt" && exec > >(tee "$GAMEDIR/log.txt") 2>&1
# Bug reports come from log.txt alone: name the build and the device.
echo "Package: $(cat VERSION 2>/dev/null || echo unknown)"
echo "Device: $DEVICE_NAME ($DEVICE_CPU, ${DEVICE_RAM} GB), $CFW_NAME $CFW_VERSION, PortMaster $PM_VERSION, kernel $(uname -r)"

# The player's disc image: plain ISO/GCM, or RVZ (Dolphin's default Zstandard or uncompressed).
disc=""
for f in gamefiles/*; do
  case "${f,,}" in
    *.iso|*.gcm|*.rvz) disc="$f"; break ;;
  esac
done
if [ -z "$disc" ]; then
  echo "No disc image in $GAMEDIR/gamefiles."
  pm_message "Copy your Super Mario Sunshine disc image (USA, GMSE01) as .iso, .gcm or .rvz into sunshine/gamefiles."
  sleep 5
  pm_finish
  exit 1
fi
echo "Disc: $disc"

# The first launch translates the game's code from the disc (a progress bar shows it) and
# keeps the result in cache/ with the shader cache; memory cards are kept in saves/.
export SDL_GAMECONTROLLERCONFIG="$sdl_controllerconfig"
$ESUDO chmod +x "$GAMEDIR/sunshine.${DEVICE_ARCH}"
mkdir -p saves cache

$GPTOKEYB "sunshine.${DEVICE_ARCH}" &
pm_platform_helper "$GAMEDIR/sunshine.${DEVICE_ARCH}"
./sunshine.${DEVICE_ARCH} "$disc" saves cache
status=$?

# A crash would otherwise leave no trace in log.txt.
if [ "$status" -gt 128 ] && [ "$status" -ne 143 ]; then
  echo "The game was stopped by signal $((status - 128))."
  dmesg 2>/dev/null | grep -i -A2 "sunshine" | tail -n 12
fi

pm_finish
