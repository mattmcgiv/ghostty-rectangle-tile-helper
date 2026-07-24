# ghostty-rectangle-tile-helper

## Overview

Tile open [Ghostty](https://ghostty.org) and [ChatGPT](https://openai.com/chatgpt/desktop/) windows on one macOS display, then raise those windows and activate the apps.

Uses only system frameworks (AppKit + Accessibility). No Rectangle dependency and no other third-party packages.

### Pure Ghostty (or pure ChatGPT)

| Open windows | Layout | Max tiled |
|---|---|---|
| 1 | 1×1 full visible frame | all |
| 2 | 1×2 halves (full height) | all |
| 3 | 1×3 thirds (full height) | all |
| 4 | 1×4 fourths (full height) | all |
| 5–6 | 2×3 sixths | all |
| 7–8 | 2×4 eighths | all |
| 9–12 | 3×4 twelfths | all |
| 13+ | 3×4 twelfths | first 12 |

Pure ChatGPT prefers full-height columns (or full-width rows) so cells stay at or above ChatGPT’s enforced minimum size (~480×600).

### Mixed Ghostty + ChatGPT

ChatGPT is laid out **first** into a reserved region that meets its minimum size, then Ghostty uses the usual grid rules in the **remaining** rectangle:

1. **Right strip** (preferred) — ChatGPT as a full-height sidebar (≥480pt wide; stacked vertically when each pane can be ≥600pt tall).
2. **Wider right strip** — multiple ChatGPT windows side-by-side when stacking would be shorter than the minimum height.
3. **Bottom strip** — full-width band (≥600pt tall) when a right strip would leave too little room.

Ghostty windows then tile inside whatever rectangle is left (1×1 through 3×4 as in the table above).

**Requirements**

- macOS with **Ghostty** and/or the **ChatGPT** desktop app installed
- **Accessibility** permission for the host that runs the script ([Raycast](https://www.raycast.com), Terminal, Shortcuts, etc.)

## Quickstart

```sh
git clone https://github.com/mattmcgiv/ghostty-rectangle-tile-helper.git
cd ghostty-rectangle-tile-helper
chmod +x bin/tile-ghostty raycast/tile-ghostty.sh
./bin/tile-ghostty
```

Open one or more Ghostty and/or ChatGPT windows, put the mouse on the target display, then run the command again. Only matching windows already on that display participate, so each monitor can have its own independent layout. A window spanning displays belongs to the display containing most of its frame. The host process must grant **Accessibility** (Terminal, Raycast, etc.) on first run.

For keyboard-driven use day to day, set up Raycast below.

## Raycast Setup

Use a [Script Command](https://github.com/raycast/script-commands) so you can tile from Raycast search or a hotkey (no Spotlight).

1. Open **Raycast Settings → Extensions → Script Commands**.
2. **Add Directories** and select this repo’s `raycast/` folder (the directory that contains `tile-ghostty.sh`).
3. Confirm **Tile Ghostty Windows** appears in the command list.
4. Assign a **Hotkey** if you want one (command detail → Hotkey).
5. First run: grant **Accessibility** to **Raycast** if prompted  
   (System Settings → Privacy & Security → Accessibility).

Search for `Tile Ghostty` in Raycast, or use your hotkey.

`raycast/tile-ghostty.sh` is a thin wrapper around `bin/tile-ghostty` (`@raycast.mode silent` so Raycast does not keep a panel open).

## How it works

1. Captures the focused Ghostty/ChatGPT window's display when invoked directly; otherwise it uses the display under the mouse (the normal Raycast path). It reads that display's **visible frame**, excluding the menu bar and Dock.
2. Finds running **Ghostty** and **ChatGPT** processes, then keeps only Accessibility (AX) windows currently on that display.
3. **Layout:** If only one app is present, uses the count-based grid (ChatGPT biased toward min-size cells). If both are present, **reserves space for ChatGPT first**, then runs the Ghostty grid in the remaining rectangle.
4. Sets each window’s `AXPosition` / `AXSize`.
5. Raises tiled windows without focus thrash: each target app is activated **once** with all windows, then that app’s tiles are `AXRaise`d while it is frontmost (ChatGPT first when present, Ghostty last so it stays key). A short delayed one-shot re-raise runs after exit so Raycast/Terminal does not keep focus.

## Configuration

| Env var | Default | Meaning |
|---|---|---|
| `TILE_GHOSTTY_SETTLE` | `0.03` | Pause between window placements (seconds). |
| `TILE_CHATGPT_MIN_WIDTH` | `480` | Minimum width reserved for each ChatGPT tile (app-enforced floor). |
| `TILE_CHATGPT_MIN_HEIGHT` | `600` | Minimum height reserved for each ChatGPT tile (app-enforced floor). |

To pass env from Raycast, edit `raycast/tile-ghostty.sh`:

```sh
export TILE_GHOSTTY_SETTLE=0.08
export TILE_CHATGPT_MIN_WIDTH=480
export TILE_CHATGPT_MIN_HEIGHT=600
exec "$TILER"
```

## Troubleshooting

- **Nothing moves:** Enable **Raycast** (or your shell host) under Accessibility.
- **Raycast does not list the command:** Confirm the `raycast/` directory is added under Script Commands → Directories, and `tile-ghostty.sh` is executable.
- **Wrong display:** Put the mouse on the target display, then run the command.
- **Partial layout:** Increase `TILE_GHOSTTY_SETTLE`; check stderr for `fails:`.
- **Apps not frontmost / some tiles buried:** Ensure Accessibility is granted for the host. The script activates each target app once and raises its tiles; only one app can be key (Ghostty when present), but both should sit above other apps. Re-run after dismissing ChatGPT floating dialogs (e.g. Computer Use) if they cover tiles.
- **ChatGPT ignored:** Confirm the desktop app process is named **ChatGPT** (bundle `com.openai.codex`). Only standard windows are tiled.
- **ChatGPT still overlaps / too small:** The desktop app clamps below ~480×600. Raise `TILE_CHATGPT_MIN_WIDTH` / `TILE_CHATGPT_MIN_HEIGHT` if a newer build requires more, or free vertical space so a right-strip stack can use full height.

## Contributing

Pull requests are welcome. See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

[MIT](LICENSE)
