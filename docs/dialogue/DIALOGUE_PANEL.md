# Dialogue panel

Owner: Claude (`feature/dialogue`). Implements **Shared Interaction–Dialogue Contract v1**.

## Files

| Path | Purpose |
|---|---|
| `scenes/ui/dialogue_panel.tscn` | Reusable panel scene, the component to instance |
| `scripts/dialogue/dialogue_panel.gd` | `DialoguePanel` (`class_name`): contract methods and signals |
| `scripts/dialogue/dialogue_library.gd` | Loads and validates conversation files; no game state |
| `data/dialogue/<conversation_id>.json` | One conversation per file |
| `tests/dialogue/` | Test substitutes and checks only, not game code |

## Interface

```gdscript
open_conversation(conversation_id: StringName) -> bool
close_conversation() -> void
is_conversation_open() -> bool

signal conversation_opened(conversation_id: StringName)
signal response_selected(conversation_id: StringName, node_id: StringName, response_id: StringName)
signal conversation_closed(conversation_id: StringName)
```

- `open_conversation` returns `true` only after the panel is visible and the first node is shown; `conversation_opened` is emitted just before it returns. Unknown, malformed or invalid conversations log a `Dialogue:` warning, return `false` and emit nothing. A request while a conversation is open is rejected the same way.
- `response_selected` is emitted once per accepted choice. Choosing an ending response emits `response_selected` and then `conversation_closed`.
- `close_conversation` (cancel) emits `conversation_closed` once and selects nothing; calling it while closed does nothing. Panel state is reset before `conversation_closed` fires, so a listener may open another conversation.
- Escape (`ui_cancel`) closes an open conversation from `_input` and marks the event handled, so gameplay `_unhandled_input` does not also see it.
- Responses accept input from the frame **after** a node appears, and only one selection is accepted per node. The press that opened the conversation cannot choose a response, and repeated presses cannot select twice.

The panel never touches the player, mouse mode, movement, quests, money, inventory, affiliation or election state. Consumers react to the signals.

### Integration notes

- Instance the scene under a `CanvasLayer`. The root is a full-rect `Control` with the default `MOUSE_FILTER_STOP`, so while visible it blocks clicks from reaching gameplay (for example `player.gd` recapturing the mouse on left-click). It is hidden when closed.
- The panel owns focus and navigation inside itself (built-in `ui_up`/`ui_down`/`ui_focus_next`/`ui_accept`; first and last responses wrap). Arrow keys are also bound to movement in `project.godot` and are read by polling, so gameplay must be locked by the interaction owner while a conversation is open. The panel does not swallow every key: for example, a keyboard Enter press on a focused button still reaches `_unhandled_input` because the button activates on release.
- Response buttons are named `Response_<response_id>`.

## Data format (schema_version 1)

```json
{
	"schema_version": 1,
	"conversation_id": "polling_officer_intro",
	"content_status": "placeholder",
	"notes": "Optional, for writers and reviewers.",
	"speakers": { "polling_officer": { "display_name": "Polling Officer" } },
	"start_node": "greeting",
	"nodes": {
		"greeting": {
			"speaker": "polling_officer",
			"text": "Visible line.",
			"responses": [
				{ "id": "here_to_vote", "text": "Visible choice.", "next": "wait_instructions" },
				{ "id": "leave", "text": "Visible choice.", "end": true }
			]
		}
	}
}
```

Validation rules, enforced at load time:

- The file name must equal `conversation_id`.
- Conversation, speaker, node and response IDs are snake_case (`^[a-z][a-z0-9_]*$`). IDs are stable keys and never visible text.
- `content_status` is `placeholder`, `proposed` or `approved`.
- Every node has a known speaker, non-empty text and at least one response.
- Response IDs are unique within a node.
- Each response has exactly one of `"end": true` or `"next"` naming an existing node.
- Every node must be reachable from `start_node` and able to reach an ending response, so the player is never left with Escape as the only way out.

Visible text is translated automatically by Godot's `Label`/`Button` auto-translate once translation files exist; text keys are not yet used.

## Checks

```bash
godot --headless --path . --script res://tests/dialogue/run_dialogue_tests.gd
```

Exit code 0 means all checks passed. The invalid fixtures intentionally print `Dialogue:` warnings.

Manual scene: open `tests/dialogue/dialogue_panel_test.tscn` and use **Run Current Scene**. It simulates the interaction side (E/Enter opens, U requests an unknown ID) and shows simulated lock/mouse state with an event log.

## Known limitations

- `polling_officer_intro` is placeholder text needing story and cultural review.
- Non-resource files are not exported by default. An export preset will need `data/dialogue/*.json` in its non-resource export filter, and should exclude `tests/*`.
- No typewriter effect, portraits, voice, conditions or variables yet. Conditional lines will need an agreed read-only game-state interface first.
