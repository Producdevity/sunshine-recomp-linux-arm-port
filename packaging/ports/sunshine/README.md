# Super Mario Sunshine

A native port of Super Mario Sunshine for Linux AArch64 handhelds. The package holds no game code:
the first launch translates the game's code from your own disc with gc-recomp and
keeps the result in `sunshine/cache`.

## Installation

Copy your disc image of Super Mario Sunshine (USA, GMSE01, revision 0) into `sunshine/gamefiles`.
Accepted: `.iso`, `.gcm`, and `.rvz` as Dolphin saves it by default (Zstandard) or
uncompressed. RVZ images compressed with bzip2 or LZMA need converting again with
Dolphin's defaults, or to ISO.

Memory card A is kept in `sunshine/saves/USA/Card A` as Dolphin GCI files.
Copy them to or from Dolphin's `GC/USA/Card A` folder to move saves between the two.
A card from an earlier version (`saves/memcard-a.raw`) is imported on first launch
and kept as `memcard-a.raw.imported`.

## Controls

Buttons are named by position, since handhelds print different labels on them.

| Handheld | GameCube |
|--|--|
| Bottom face button | A |
| Left face button | B |
| Right face button | X |
| Top face button | Y |
| L1, L2 | L |
| R2 | R |
| R1 | Z |
| Start | Start |
| D-Pad | D-Pad |
| Left stick | Control stick |
| Right stick | C stick |

PortMaster's exit chord (usually Select + Start) quits and saves the memory card.

## Notes

- Requires OpenGL ES 3.1 and glibc 2.27 or newer.
- `sunshine/log.txt` holds the log of the last run.

## Thanks

- Function list: [doldecomp/sms](https://github.com/doldecomp/sms), the Super Mario Sunshine decompilation (CC0).
- Rendering: Starlet (GPL-3.0). RVZ decompression: zstd (BSD).
