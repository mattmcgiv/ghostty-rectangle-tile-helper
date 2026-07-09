# Contributing

Thanks for your interest in improving this project. **Pull requests are welcome.**

## Ways to help

- Bug reports and reproducible edge cases (multi-monitor, many windows, Accessibility hosts)
- Layout or focus improvements that stay dependency-free
- Docs and Raycast / CLI ergonomics
- Small, focused refactors that make the Swift script easier to follow

## Before you open a PR

1. Fork the repo and create a branch from `main`.
2. Keep changes focused: one idea per PR when you can.
3. Update `README.md` if behavior or setup steps change.
4. Test on macOS with real Ghostty windows (1 through 6+ if layout logic is involved).
5. Do not commit secrets, personal absolute paths, or machine-specific config.

## Development notes

- The tiler is a single executable Swift script: `bin/tile-ghostty` (`#!/usr/bin/swift`).
- Raycast entry point: `raycast/tile-ghostty.sh` (must stay executable; keep `@raycast.*` metadata intact).
- Prefer AppKit + Accessibility only—no third-party window managers or packages.
- Layout rules live near the top of `bin/tile-ghostty` and in the README Overview table; keep them in sync.

### Quick local check

```sh
chmod +x bin/tile-ghostty raycast/tile-ghostty.sh
./bin/tile-ghostty
```

Confirm windows move as expected and Ghostty ends up frontmost when launched from Terminal and from Raycast.

## Pull request checklist

- [ ] Clear description of the problem and the change
- [ ] Tested with Ghostty on macOS
- [ ] README (and comments) updated if user-facing behavior changed
- [ ] No sensitive or machine-specific data

## Code of conduct (lightweight)

Be respectful and constructive. Assume good intent. We’re all here to make a small tool better.

## License

By contributing, you agree that your contributions are licensed under the [MIT License](LICENSE).
