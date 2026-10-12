# Codex interaction handoff — contract version 1

Owned branch: `feature/interaction`. Baseline: `75465dcbe3055c40ee869c85ab6d0f7032b5d673`.
All changes remain local, unstaged and uncommitted. The Claude worktree was not inspected or modified.

## Owned files

- `player.gd`: independent movement/look input switches; existing physics and camera behavior preserved.
- `project.godot`: one new `interact` Input Map action, physical E.
- `scripts/interaction/interaction_target.gd` and its `.uid`: reusable target marker.
- `scripts/interaction/interaction_controller.gd` and its `.uid`: reusable interaction/controls owner.
- `scenes/interaction/interaction_controller.tscn`: controller and lightweight prompt HUD.
- `tests/interaction/dialogue_panel_substitute.gd` and its `.uid`, plus its `.tscn`: isolated technical panel substitute.
- `tests/interaction/dialogue_substitute_data.json`: offline technical fixture data, separate from UI code.
- `tests/interaction/interaction_playtest.tscn`: existing polling world plus a labelled capsule test target and substitute panel.
- `tests/interaction/interaction_checks.gd` and its `.uid`: headless integration checks.
- This handoff file.

`polling_unit.tscn`, the renderer, main scene selection and dependencies are unchanged.
The baseline had no interaction action, so adding E to shared project configuration was necessary.
The baseline player had no control lock API, so the player script adds the smallest switches needed to pause horizontal input/look while maintaining gravity, collision and respawn.

## Reusable components and integration

Instance `res://scenes/interaction/interaction_controller.tscn` beside the player and Claude's panel.
Set its `player_path` to the existing Player, and `dialogue_panel_path` to the node supplying the contract-v1 panel methods/signals. Paths are relative to the controller node. The test scene uses `../PollingUnit/Player` and `../DialoguePanelSubstitute` respectively.

Attach `res://scripts/interaction/interaction_target.gd` to an interactable world object or its Node3D marker. Configure its stable `target_id`, stable `conversation_id`, display name, enabled state and interaction offset. The shared ID is `polling_officer_intro`. This script can be attached to a StaticBody3D; collision belongs to the world object. A marker does not add collision by itself.

The controller selects the nearest enabled target within a 3 metre full 3D range, measured from player position plus one metre upward to the target's interaction point. A ray on physics layer 1 excludes the player and prevents requests through solid obstacles; the target itself and its collider descendants are accepted. Range/mask are exported settings. No facing-direction requirement is imposed for this first prototype.

The controller checks reachability again after consuming E and deferring the open until input dispatch finishes. It calls only the panel's agreed interface, with no dependency on a Claude script/resource/class path:

```gdscript
open_conversation(conversation_id: StringName) -> bool
close_conversation() -> void
is_conversation_open() -> bool

conversation_opened(conversation_id: StringName)
response_selected(conversation_id: StringName, node_id: StringName, response_id: StringName)
conversation_closed(conversation_id: StringName)
```

There are no contract deviations. The production controller contains no dialogue content and does not change quests, money, inventory, political affiliation or election outcomes. The response signal is available for a future gameplay owner; this implementation does not consume it for state changes.

Keep the panel before the controller in scene-tree order for the controller to receive Escape first. The panel must also consume its cancellation input before closing, as required by the contract. Closed-signal restoration is deferred until input dispatch finishes, covering a panel receiving Escape first too.

Only a successful open with the panel still active locks movement/look and makes the mouse visible. Synchronous closure during opening never locks controls. On close the controller restores the independently saved movement, look and mouse states. It keeps player physics running and handles provider/controller removal. Key echoes cannot reopen. Targets removed before a deferred request are ignored; removing a target during an active conversation does not prevent closing it.

The player exposes `is_movement_input_enabled()`, `is_look_input_enabled()`, and `set_gameplay_input_enabled(movement_enabled: bool, look_enabled: bool)`. Claude's panel must not call them or change the mouse mode. The controller component is intended to live and be freed with its gameplay scene.

## Isolated playable fixture

Open `tests/interaction/interaction_playtest.tscn` and run the current scene with F6. F5 still starts the existing environment without a dialogue mock. Walk from the entrance to the labelled blue capsule beside the canopy; approach within three metres and press E. The substitute is explicitly technical, with no polling-officer narrative. It supplies a focused response button and Cancel, supports standard UI navigation, emits stable `intro` / `test_response` IDs, and blocks the opening event and repeated selections. Its content comes from its JSON fixture.

After the owner integrates Claude's accepted work, wire the controller to the actual panel, place the production target, and retain the substitute only in `tests/interaction`. No merge or integration of Claude's uncommitted code was attempted here.

## Verification and remaining playtests

Godot 4.7.2 headless editor import validates all scripts/resources. Main scene and isolated playtest startup are checked separately. Run the regression suite with:

```bash
/home/favour-nwachukwu/Applications/Godot/godot --headless --path /home/favour-nwachukwu/Projects/election-wahala-codex --script res://tests/interaction/interaction_checks.gd
```

Executed in the assigned Codex worktree with Godot 4.7.2: editor import passed, main and isolated playtest scenes each started for 30 frames, and the suite passed **53 checks, 0 failures**. All four final logs contain no errors or warnings. `git diff --check` and whitespace checks on new files passed; HEAD, index entries and `polling_unit.tscn` remain unchanged. Logs are `/tmp/election-wahala-codex-interaction-editor.log`, `/tmp/election-wahala-codex-interaction-checks.log`, `/tmp/election-wahala-codex-main-load.log` and `/tmp/election-wahala-codex-interaction-load.log`.

The suite covers physical E mapping, target selection/range/obstructions, failed and concurrent opens, deferred stale targets, input consumption, exact prior movement/look restoration, stable signal IDs, duplicate response suppression, natural/cancel closure, panel/controller removal, existing walking/sprinting/camera-relative movement/wall collision, spring-arm collision, and locked gravity/respawn. Review of the source checks the pitch clamp remains unchanged.

Windowed playtesting still needs to confirm:

- Captured mouse is restored after dialogue; previously released mouse remains released, and click recaptures during gameplay.
- Escape closes dialogue without releasing the restored captured mouse, including held/repeated keys.
- E opens once and never chooses a response; held Enter/click cannot select on opening or select twice.
- Up/Down, Tab, Enter/Space and click focus/navigation feel correct; Cancel and the natural ending restore movement/look.
- Prompt, placeholder, panel readability and comfortable range around the table/canopy.
- Camera pitch limits, wall avoidance and frame rate on Iris Xe.

The headless display backend cannot prove actual pointer capture, windowed input/focus comfort, visual quality or hardware performance. Claude's real panel has not been tested because isolated ownership forbids reading its uncommitted implementation.

Suggested owner commit message: `Add isolated interaction controller and dialogue contract playtest`.
