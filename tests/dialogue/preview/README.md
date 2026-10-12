# Dialogue layout preview tools

Review aids for the compact dialogue layout (`feature/dialogue-layout`). They are not game code and not part of the automated suites. Each script opens a real Godot window for a few seconds and saves a screenshot.

| File | Purpose |
|---|---|
| `capture_test_scene.gd` | Opens `tests/dialogue/dialogue_panel_test.tscn`, starts a conversation and saves a screenshot |
| `capture_courtyard.gd` | Opens `tests/integration/interaction_dialogue_playtest.tscn`, stands the player near the placeholder officer, presses E, then optionally checks a mouse click, keyboard selection or wheel scrolling |
| `layout_stress.json`, `layout_many.json` | Layout-only conversations: long text with five choices, and ten choices. Placeholder text. Not loaded by the game |

Run from the project folder, passing arguments after `--`:

```bash
godot --path . --windowed --resolution 640x360 --script res://tests/dialogue/preview/capture_test_scene.gd -- out=/abs/path/shot.png
godot --path . --windowed --resolution 640x360 --script res://tests/dialogue/preview/capture_test_scene.gd -- out=/abs/path/shot.png stress=/abs/path/to/tests/dialogue/preview id=layout_many focus_last=1
godot --path . --windowed --resolution 1152x648 --script res://tests/dialogue/preview/capture_courtyard.gd -- out=/abs/path/shot.png mode=click
```

`capture_courtyard.gd` modes are `open`, `click`, `keys` and `scroll`; `scroll` also needs `stress=<folder holding layout_many.json>`. It needs the combined playtest scene, which currently exists only as uncommitted work in the integration worktree, so it does not run on this branch alone.

The 12 October 2026 review is recorded in `docs/previews/courtyard_review.md` with one representative screenshot. The full screenshot sets and the PDF summary are kept locally under `docs/previews/` and ignored by Git.
