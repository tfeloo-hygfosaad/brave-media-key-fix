# brave-media-key-fix
A small user-level systemd service that broadcasts Play/Pause media key events to multiple MPRIS players using `playerctl`.

This exists to work around Brave intercepting media keys via `brave-plasma-integration`, which makes media key handling mutually exclusive between Brave and standalone media players (e.g. Strawberry).

## Background / Why this exists

With `brave-plasma-integration` enabled:

- Brave aggressively claims media key events via MPRIS
- KDE Plasma forwards Play/Pause to **exactly one** active player
- Result: either Brave **or** your music player is able to listen — never both

On X11 this is less noticeable because global key handling is permissive.
On Wayland this behavior is strict and unavoidable by design.

This service sidesteps the issue by:
- Listening for media state changes via MPRIS
- Explicitly forwarding Play/Pause to all relevant players

No compositor hacks, no key interception, no browser flags.

## What it does

- Blocks on media events using `playerctl`
- Toggles Play/Pause on:
  - A fixed list of players (default: `haruna`, `strawberry`)
  - All running Brave MPRIS instances (detected dynamically)

## Files

- `media-broadcast`  
  Media event listener and broadcaster.

- `media-broadcast.service`  
  User-level systemd service.

## Requirements

- Linux (this was created for CachyOS, but should work in most distros, I imagine)
- `playerctl`
- systemd user services
- KDE Plasma (tested)
- Brave with `brave-plasma-integration` enabled

## Installation

Install and enable the service:
```bash
make install
```

Remove everything cleanly:

```bash
make uninstall
```

### What make install does

1. Installs the script to ~/.local/bin/media-broadcast.
2. Installs the systemd user service to ~/.config/systemd/user/.
3. Reloads the systemd user daemon.
4. Enables the service (starts now and on login).

### Verify it’s running

```bash
systemctl --user status media-broadcast.service
```

## Configuration

Edit `media-broadcast`:

```bash
MAIN_PLAYERS=("haruna" "strawberry")
```

## Notes / Limitations

- Relies on MPRIS behavior (no raw key access)
- Handles Play/Pause only (no seeking, volume, etc.)
- Player names are hard-coded by design
- Not packaged (intended as a personal utility)
