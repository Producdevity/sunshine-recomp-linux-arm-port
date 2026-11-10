# Third-party material

## config/GMSE01.symbols.txt

Function names and addresses of Super Mario Sunshine (USA, GMSE01), copied unchanged from
`config/GMSE01/symbols.txt` of doldecomp/sms, the Super Mario Sunshine decompilation:

- Source: https://github.com/doldecomp/sms
- Revision: 4b2fd238058bf70822ca226e17f02879a7a46eb4
- License: CC0 1.0 Universal (the repository's `LICENSE` file), shipped as
  `licenses/LICENSE.doldecomp-sms.txt` (`config/LICENSE.doldecomp-sms.txt` here)

The port uses the list only to find function boundaries when it translates the game's code
from the player's disc. It contains no game code.

## Linked libraries

- Starlet (GameCube/Wii GX renderer): GPL-3.0, `licenses/LICENSE.starlet.txt` in the package.
- zstd (Zstandard decompression, through Starlet's `third_party/zstd`, v1.5.6): BSD,
  `licenses/LICENSE.zstd.txt` in the package.
- SDL2, OpenGL ES and the C/C++ runtime come from the device and are not shipped.
