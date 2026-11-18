# Roblox Studio playtest and publishing checklist

## Current status
Code is committed, but no Studio execution, visual capture, binary place export, public publish, icon review, or official checker has been verified.

## Build
1. Install Roblox Studio and Rojo.
2. Open Roblox Studio, create a blank Baseplate experience, and start Rojo serve from the repository using `rojo serve`.
3. Connect the Rojo Studio plugin to localhost and sync `default.project.json`.
4. Test with one player, then with multiple clients.
5. Check: purchase cost deducted once, correct income/sec, rebirth resets collection and increases future income, meteor damage only outside safe base, respawn at assigned base, all eight bases assigned once, leaving player frees slot.
6. Inspect Output for Luau runtime errors and test UI on phone viewport.

## Before submission
- Follow official kit instructions and record actual supported coding-agent sessions. Direct GitHub edits alone do not establish eligible provenance.
- Produce a binary `game.rbxl` (not XML `.rbxlx`) from Studio.
- Publish a Public experience using an eligible Roblox account; upload a custom icon and thumbnail and wait for moderation approval.
- Add the public play link to `PLAY.json` and add the make.fun play code to the experience description.
- Capture 3–4 actual screenshots; each must be <= 256 KiB, with one identical to the first approved Roblox thumbnail.
- Copy all game scripts as .luau files under src, import official vendor kit unchanged, and run its acceptance checker.
- Obtain user approval before submitting.
