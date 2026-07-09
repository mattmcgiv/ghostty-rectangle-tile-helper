# ghostty-rectangle-tile-helper

Tile open [Ghostty](https://ghostty.org) windows on macOS into a fixed grid, then bring Ghostty to the foreground.

Uses only system frameworks (AppKit + Accessibility). No Rectangle dependency and no other third-party packages.

| Open Ghostty windows | Layout | Max tiled |
|---|---|---|
| 1–2 | 2×2 quarters (fill first cells) | all |
| **3** | **1×3 thirds** (full height) | all |
| 4 | 2×2 quarters | all |
| 5+ | 2×3 sixths | first 6 |

## Requirements

- macOS with **Ghostty** installed
- **Accessibility** permission for the host that runs the script ([Raycast](https://www.raycast.com), Terminal, Shortcuts, etc.)

## Install

```sh
git clone https://github.com/mattmcgiv/ghostty-rectangle-tile-helper.git
cd ghostty-rectangle-tile-helper
chmod +x bin/tile-ghostty raycast/tile-ghostty.sh
```

## Raycast

Use a [Script Command](https://github.com/raycast/script-commands):

1. Open **Raycast Settings → Extensions → Script Commands**.
2. **Add Directories** and select this repo’s `raycast/` folder (the directory that contains `tile-ghostty.sh`).
3. Confirm **Tile Ghostty Windows** appears in the command list.
4. Assign a **Hotkey** if you want one (command detail → Hotkey).
5. First run: grant **Accessibility** to **Raycast** if prompted  
   (System Settings → Privacy & Security → Accessibility).

Search for `Tile Ghostty` in Raycast, or use your hotkey.

`raycast/tile-ghostty.sh` is a thin wrapper around `bin/tile-ghostty` (`@raycast.mode silent` so Raycast does not keep a panel open).

## CLI

```sh
./bin/tile-ghostty
```

## How it works

1. Finds the Ghostty process and its Accessibility (AX) windows.
2. Reads the **visible frame** of the display under the mouse (excludes menu bar / dock).
3. Chooses a grid by window count (see table above).
4. Sets each window’s `AXPosition` / `AXSize`.
5. Raises tiled windows and activates Ghostty (plus a short delayed re-activate so the launcher does not keep focus).

## Configuration

| Env var | Default | Meaning |
|---|---|---|
| `TILE_GHOSTTY_SETTLE` | `0.03` | Pause between window placements (seconds). |

To pass env from Raycast, edit `raycast/tile-ghostty.sh`:

```sh
export TILE_GHOSTTY_SETTLE=0.08
exec "$TILER"
```

## Troubleshooting

- **Nothing moves:** Enable **Raycast** (or your shell host) under Accessibility.
- **Raycast does not list the command:** Confirm the `raycast/` directory is added under Script Commands → Directories, and `tile-ghostty.sh` is executable.
- **Wrong display:** Put the mouse on the target display, then run the command.
- **Partial layout:** Increase `TILE_GHOSTTY_SETTLE`; check stderr for `fails:`.
- **Ghostty not frontmost:** Ensure Accessibility is granted; the script raises windows and runs a delayed `activate`.

## License

[MIT](LICENSE)
