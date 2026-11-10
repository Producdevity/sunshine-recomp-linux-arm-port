# Super Mario Sunshine

A native port of Super Mario Sunshine for Linux AArch64 handhelds. The package holds no game code:
the first launch translates the game's code from your own disc with gc-recomp and
keeps the result in `sunshine/cache`.

## Installation

Copy your disc image of Super Mario Sunshine (USA, GMSE01, revision 0) into `sunshine/gamefiles`.
Accepted: `.iso`, `.gcm`, and `.rvz` as Dolphin saves it by default (Zstandard) or
uncompressed. RVZ images compressed with bzip2 or LZMA need converting again with
Dolphin's defaults, or to ISO. Memory cards are kept in `sunshine/saves`.

## Controls

The GameCube layout on the handheld's buttons. PortMaster's exit chord (usually Select + Start) quits.

## Notes

- Requires OpenGL ES 3.1 and glibc 2.27 or newer.
- `sunshine/log.txt` holds the log of the last run.

## Thanks

- Function list: [doldecomp/sms](https://github.com/doldecomp/sms), the Super Mario Sunshine decompilation (CC0).
- Rendering: Starlet (GPL-3.0). RVZ decompression: zstd (BSD).
