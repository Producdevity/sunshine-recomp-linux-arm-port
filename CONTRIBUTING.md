# Contributing

Contributions are welcome: bug reports, fixes, device support and performance work.

## Understand what you submit

Be ready to explain every line you add or remove, and why, in your own words. AI assistants
are fine to use: review what they write as you would anyone else's code, and say in the pull
request that you used one. If you can't explain a change yet, open an issue or a draft pull
request and ask; that is a good way to start.

## What belongs here

This repository holds the Super Mario Sunshine port: its per-game configuration, build and
packaging. Recompiler and runtime changes belong in [gc-recomp](https://github.com/Producdevity/gc-recomp); console and SDK behaviour that
other ports share belongs in [Starlet](https://github.com/Producdevity/starlet).

## Pull requests

- Keep each pull request to one change a reviewer can read line by line. Keep related changes
  together and unrelated ones apart.
- Fix a reported problem or a clear gap. Open an issue first for larger features, so we can
  agree on the approach before you build it.
- Follow the surrounding code. Add a comment only where the code can't explain itself, such
  as a hardware quirk or an external constraint.
- Write commit titles as `type(scope): summary`, for example `fix(platform): ...`, in at most
  72 characters.
- Describe the change briefly in your own words, with what you tested: commands, device,
  firmware and GPU driver, and before/after numbers for performance changes.

## Testing

- Run the host tests described in the README.
- Test on a handheld through its frontend and the PortMaster launcher, and name the device,
  firmware and GPU driver (for example Mali r20p0 or Panfrost).

## Game data

Keep game files out of the repository: disc images, executables, extracted assets, saves,
and code copied from a game or the console SDK. Players supply their own disc.

## License

Contributions are licensed under the GNU General Public License v3.0, like the port's own
code.
