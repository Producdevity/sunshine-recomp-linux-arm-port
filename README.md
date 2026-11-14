# Super Mario Sunshine for Linux AArch64 handhelds

A native port of Super Mario Sunshine on [gc-recomp](https://github.com/Producdevity/gc-recomp) and [Starlet](https://github.com/Producdevity/starlet). The first launch translates the
game's code from the player's own disc; the repository and the package hold no game
code. The PortMaster package and its player notes are in
[packaging/ports/sunshine](packaging/ports/sunshine/README.md).

## Building

Clone with the submodules ([gc-recomp](https://github.com/Producdevity/gc-recomp), and [Starlet](https://github.com/Producdevity/starlet) inside it):

```sh
git clone --recurse-submodules <repository URL>
```

Cross-compile for AArch64 Linux with clang and a Debian bullseye arm64 sysroot that has
SDL2 and GLES 3 development files. Build gc-recomp's host `gcrecomp` first, then:

```sh
cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_TOOLCHAIN_FILE=third_party/gc-recomp/cmake/aarch64-linux.cmake \
  -DGC_SYSROOT=<sysroot> -DGC_CLANG=<clang> -DGC_CLANGXX=<clang++> -DGC_LLD=<ld.lld> \
  -DGC_RECOMPILER=<host gcrecomp> -DSTARLET_GLES_INCLUDE_DIR=<sysroot>/usr/include \
  -DSTARLET_GLES_LIBRARY=<sysroot>/usr/lib/aarch64-linux-gnu/libGLESv2.so
cmake --build build --target sunshine
tools/package-portmaster.sh build dist
```

`-DGC_RECOMP_DIR=<checkout>` builds against a local gc-recomp instead of the submodule.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## Licenses

This project is licensed under the GNU General Public License v3.0; see
[LICENSE](LICENSE). [gc-recomp](https://github.com/Producdevity/gc-recomp) and [Starlet](https://github.com/Producdevity/starlet) are GPL-3.0, the function list from
doldecomp/sms, the Super Mario Sunshine decompilation is CC0-1.0, and the Zstandard
decoder Starlet links is BSD-licensed; see [third-party material](THIRD_PARTY.md). Code
translated from the player's disc remains the game's and is not covered by this license.
