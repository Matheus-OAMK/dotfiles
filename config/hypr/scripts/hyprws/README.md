# hyprws

`hyprws` is a small Bash utility for toggling Hyprland special workspaces with optional app spawning and client moves.

## What it does

- toggles `special:<workspace>` through `hyprctl dispatch togglespecialworkspace`
- optionally spawns an app into that special workspace when no matching client exists
- optionally moves matching existing clients into that special workspace
- supports a `specialws` shortcut that toggles the currently active special workspace on the focused monitor

## Requirements

- `bash`
- `jq`
- `hyprctl`

## Usage

```bash
./hyprws music
./hyprws communication
./hyprws sysmon
./hyprws specialws
```

## Config

Default config lives at `config/default.json`.

Optional user overrides live at `~/.config/hyprws/config.json` and are merged on top of the defaults.

Example:

```json
{
  "music": {
    "spotify": {
      "enabled": true,
      "match": [{ "class": "Spotify" }, { "initialTitle": "Spotify" }],
      "spawn": ["spotify-launcher"],
      "move": true
    }
  }
}
```

## Match semantics

Each entry under `match` is treated as OR.

Inside one match object, keys are treated as AND.

String values use substring matching to preserve the original behavior from Caelestia. That means `{ "class": "discord" }` matches a client whose class contains `discord`.

## Notes

- If any configured app is spawned, `hyprws` does not immediately toggle the workspace afterward. This matches the original behavior and avoids instantly hiding the newly launched window.
- Spawn commands are executed directly through Hyprland without `app2unit`.
