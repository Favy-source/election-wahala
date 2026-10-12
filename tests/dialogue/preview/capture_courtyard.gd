extends SceneTree
## Scratch-only courtyard check. Args after "--": out=<png> mode=open|click|keys|scroll [stress=<dir>]

var selected: Array = []

func _initialize() -> void:
	_go.call_deferred()

func _action(name: StringName, pressed: bool) -> void:
	var e := InputEventAction.new(); e.action = name; e.pressed = pressed
	root.push_input(e)

func _mouse_button(pos: Vector2, button: MouseButton, pressed: bool) -> void:
	var e := InputEventMouseButton.new(); e.button_index = button; e.pressed = pressed
	e.position = pos; e.global_position = pos
	root.push_input(e, true)

func _frames(n: int) -> void:
	for i in n: await process_frame

func _go() -> void:
	var args := {}
	for a in OS.get_cmdline_user_args():
		var kv := a.split("=", true, 1); args[kv[0]] = kv[1] if kv.size() > 1 else ""
	var mode: String = args.get("mode", "open")
	var scene: Node = load("res://tests/integration/interaction_dialogue_playtest.tscn").instantiate()
	root.add_child(scene)
	var player: CharacterBody3D = scene.get_node("PollingUnit/Player")
	var panel = scene.get_node("DialogueLayer/DialoguePanel")
	panel.response_selected.connect(func(c, n, r): selected.append([n, r]))
	# Stand within interaction range, looking past the player at the officer (x 3.8).
	player.global_position = Vector3(2.3, 1.0, 1.5)
	player.get_node("CameraPivot").rotation.y = -PI / 4.0
	await _frames(30)
	if mode == "scroll":
		panel.dialogue_directory = args.stress
		print("open layout_many: ", panel.open_conversation(&"layout_many"))
	else:
		_action(&"interact", true); await _frames(2); _action(&"interact", false)
	await _frames(6)
	print("panel open: ", panel.is_conversation_open(), "  mouse mode: ", Input.mouse_mode)
	var list: Node = panel.get_node("%ResponseList")
	if mode == "click":
		var target: Control = list.get_node("Response_ask_unit")
		var pos := target.get_global_rect().get_center()
		var m := InputEventMouseMotion.new(); m.position = pos; m.global_position = pos; root.push_input(m, true)
		await _frames(2)
		_mouse_button(pos, MOUSE_BUTTON_LEFT, true); await _frames(2); _mouse_button(pos, MOUSE_BUTTON_LEFT, false)
		await _frames(6)
		print("after click selected=", selected, " body='", panel.get_node("%BodyLabel").text.left(40), "...'")
	elif mode == "keys":
		_action(&"ui_down", true); _action(&"ui_down", false); await _frames(3)
		print("focus after Down: ", root.gui_get_focus_owner().name)
		_action(&"ui_accept", true); await _frames(2); _action(&"ui_accept", false); await _frames(6)
		print("after Enter selected=", selected, " body='", panel.get_node("%BodyLabel").text.left(40), "...'")
	elif mode == "scroll":
		var scroll: ScrollContainer = panel.get_node("%ResponseScroll")
		var pos := scroll.get_global_rect().get_center()
		var before := scroll.scroll_vertical
		for i in 3:
			_mouse_button(pos, MOUSE_BUTTON_WHEEL_DOWN, true); _mouse_button(pos, MOUSE_BUTTON_WHEEL_DOWN, false)
			await _frames(2)
		print("wheel scroll: ", before, " -> ", scroll.scroll_vertical, " (list ", list.size.y, " px, view ", scroll.size.y, " px)")
	await _frames(4)
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(args.out)
	var frame: Control = panel.get_node("%Frame")
	print("saved ", args.out.get_file(), " window=", root.size, " logical=", root.get_visible_rect().size, " frame=", frame.size)
	quit()
