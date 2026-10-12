# Interaction–dialogue integration handoff — contract version 1

Worktree: `/home/favour-nwachukwu/Projects/election-wahala-integration`.
Branch: `integration/interaction-dialogue`.

## Local Git provenance and ownership

The owner explicitly authorised creation of this branch/worktree from `main` and local merges of both feature branches. Before integration, both feature worktrees were clean and the owner had committed their implementations:

- Main/environment baseline: `75465dcbe3055c40ee869c85ab6d0f7032b5d673`.
- Interaction: `a034a4884371b5bfc6accf65f45a3c093b5c6f61`.
- Dialogue: `3bf6c6782b3ff90aebc29a9408970b8f6bc614fb`.

Interaction merged by fast-forward. Dialogue merged without conflicts, producing authorised local merge commit `29f35dd4ba2a0a912c4c4fcf24ea322a611d1b6d`. The new implementation files listed below remain unstaged and uncommitted for owner review. Main and both feature worktrees were not modified. No push or remote operation was performed.

This assignment owns only:

- `tests/integration/interaction_dialogue_playtest.tscn`: a separate combined playable fixture.
- `tests/integration/run_integration_checks.gd` and its `.uid`: focused combined behaviour checks.
- `docs/handoffs/integration_v1.md`: this integration record.

Existing player/camera behaviour, production interaction and dialogue components, both standalone fixtures and suites, `polling_unit.tscn`, `assets/meshes/moulded_plastic_chair.tres`, `docs/ART_DIRECTION.md`, main scene selection and Compatibility renderer settings are preserved. No dependency, asset download, new gameplay feature or contract change was introduced.

## Combined scene and interface

Open `res://tests/integration/interaction_dialogue_playtest.tscn` and run the current scene with **F6**. F5 continues to launch the existing main environment.

The combined scene instances the committed polling environment, reusable interaction controller, and Claude's real `res://scenes/ui/dialogue_panel.tscn`. Its labelled blue capsule is a polling-officer placeholder, not a final character. The panel is hosted under `DialogueLayer`, a `CanvasLayer` with layer 20. The test instructions use layer 30.

Controller paths are relative to `InteractionController`, and the combined checks resolve them against the actual scene tree:

```text
player_path: ../PollingUnit/Player
dialogue_panel_path: ../DialogueLayer/DialoguePanel
```

The target's stable ID is `polling_officer_test_target`; its conversation ID is `polling_officer_intro`. Dialogue data remains in `data/dialogue/polling_officer_intro.json`. Its text is provisional content, not an authoritative description of election procedures.

The contract-v1 public methods and signals are unchanged. Codex's controller still identifies and checks reachable targets, consumes and defers opening input, locks gameplay only after successful opening, and restores the independently saved movement/look flags and mouse mode on close. Claude's panel still owns content, response selection, focus and UI navigation. No dialogue response changes quests, money, inventory, affiliation or election outcomes.

The panel precedes the controller in the combined scene, so the controller receives cancellation first under Godot's reverse input order. Both components consume cancellation before closing; tests also move the controller to exercise the opposite input order. Deferred restoration keeps Escape from reaching normal gameplay handling. No compatibility patch to either production component was necessary.

The existing substitute remains only in its original `tests/interaction` fixture. The new suite does not depend on substitute-specific response IDs or widget structure.

## Automated verification

Using Godot `4.7.2.stable.official.ed1daf0bf` in the integration worktree:

| Check | Result |
|---|---|
| Headless editor import | Passed; no script/resource errors |
| Existing interaction suite | 53 checks passed, 0 failures |
| Existing dialogue suite | 50 checks passed, 0 failures |
| Combined headless suite | 315 checks passed, 0 failures |
| Display-backed combined suite | 348 checks passed, 0 failures; X11 display, 3 captured-mouse scenarios |

The dialogue suite deliberately tests malformed/missing content and active-open rejection: its 13 `Dialogue:` / `DialoguePanel:` warnings are expected negative-test results. The combined suite deliberately requests `unknown_integration_conversation`, producing one expected unknown-ID warning per run. These warnings are separate from actual failures; no unexpected warning/error was found in the final runs.

The combined suite exercises all six complete paths in the actual conversation data, stable IDs and signal ordering, successful-open locking, natural and cancelled completion, opening-input isolation, held/repeated E/Enter/Space and mouse clicks, Up/Down wrapping, Tab/Shift-Tab focus, both Escape input orders, all four previous movement/look combinations, visible-mouse restoration, locked camera/horizontal movement, ongoing gravity, floor/wall collision, falling-off-map respawn, failed opens followed by usable movement, and synchronous closure during opening.

Headless mouse capture is unavailable: the combined headless run explicitly skipped captured-mouse restoration and gameplay click recapture. The X11 run passed captured-mouse restoration after Escape, restoration after natural completion, and gameplay click recapture. Its additional checks include a captured-mouse conversation route and optional preview export. That run produced only the same one expected unknown-ID warning, with no errors. Synthetic input checks establish runtime behaviour; they do not establish human input comfort or device performance.

The final editor import and headless repeat after adding optional preview export also passed. Read-only checks confirmed the original three worktrees remain clean with unchanged HEAD/index entries, and the integration worktree has no tracked-file or staged changes. Its four new implementation/documentation files remain untracked for owner review. The Lagos environment, chair mesh and art-direction document match the original committed baseline.

Logs: `/tmp/election-wahala-integration-import.log`, `/tmp/election-wahala-integration-interaction.log`, `/tmp/election-wahala-integration-dialogue.log`, `/tmp/election-wahala-integration-combined-headless.log`, and `/tmp/election-wahala-integration-combined-windowed.log`.

Reproduce from the integration worktree (use the installed executable shown here, or an equivalent Godot executable of the recorded version):

```bash
cd /home/favour-nwachukwu/Projects/election-wahala-integration
/home/favour-nwachukwu/Applications/Godot/godot --headless --path . --editor --quit
/home/favour-nwachukwu/Applications/Godot/godot --headless --path . --script res://tests/interaction/interaction_checks.gd
/home/favour-nwachukwu/Applications/Godot/godot --headless --path . --script res://tests/dialogue/run_dialogue_tests.gd
/home/favour-nwachukwu/Applications/Godot/godot --headless --path . --script res://tests/integration/run_integration_checks.gd
/home/favour-nwachukwu/Applications/Godot/godot --path . --script res://tests/integration/run_integration_checks.gd
```

The last command needs a working display. An optional user argument, `-- --snapshot=/tmp/election-wahala-dialogue-preview.png`, saves a rendered preview during the display-backed run. This is a temporary review artifact, not a project asset.

## Windowed observations and manual playtest

The X11 run used the existing GL Compatibility renderer on Intel Iris Xe TGL GT2 with Mesa 25.2.8. The rendered preview `/tmp/election-wahala-integration-dialogue-preview.png` was inspected: the school and canopy remained visible; the real panel's greeting and all three responses fit at 1280 × 720; the first response's focus outline was visible. This is a static rendered observation. No human-driven play session or Iris Xe frame-rate measurement has been performed.

Open `tests/integration/interaction_dialogue_playtest.tscn` in the integration worktree's Godot editor and press **F6**:

1. Walk from the entrance to the labelled officer capsule beside the voting area. Confirm the prompt appears only nearby with a clear route; press E once and hold it separately. Dialogue should open once without selecting a response.
2. Check that WASD/arrows, Shift and mouse look stop during dialogue, while the player remains supported by collision. Confirm the prompt and panel remain readable and the pointer is visible.
3. Navigate with Up/Down, Tab/Shift-Tab, Enter/Space and mouse clicks. Try held/repeated keys, double-clicks and clicks carried into opening; each deliberate response should advance once.
4. Complete all six paths: direct voting → wait/return later; ask unit → voting → wait/return later; direct passing; ask unit → passing. Each final `end_conversation` response should close once and restore gameplay.
5. Open from captured gameplay, then cancel with Escape. It should close dialogue and restore capture without also releasing it. Hold Escape to check repeat behaviour. A fresh gameplay Escape should release the mouse normally.
6. Release the mouse before opening, then cancel and complete dialogue. It should remain visible after each close; a fresh gameplay click should recapture it. Check that restored controls and camera feel unchanged.
7. Walk around the canopy, table, courtyard walls and gate. Check camera clipping/comfort, accessible routes, preserved Lagos details, UI contrast/scale and frame rate on the intended Iris Xe machine.

Remaining limitations are final placeholder character/dialogue content, human navigation and mouse comfort, visual/camera review and hardware performance. The combined fixture is a playtest scene; the production main scene has not been rewired.

Suggested owner commit message: `Add combined interaction and dialogue playtest coverage`.
