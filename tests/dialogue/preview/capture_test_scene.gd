extends SceneTree
## Scratch preview capture: opens the dialogue test scene, opens a
## conversation and saves a screenshot. Args after "--": out=<png> [stress=<dir>]

func _initialize() -> void:
	_go.call_deferred()

func _go() -> void:
	var args := {}
	for a in OS.get_cmdline_user_args():
		var kv := a.split("=", true, 1)
		args[kv[0]] = kv[1] if kv.size() > 1 else ""
	var scene: Node = load("res://tests/dialogue/dialogue_panel_test.tscn").instantiate()
	root.add_child(scene)
	var panel = scene.get_node("%DialoguePanel")
	var id := &"polling_officer_intro"
	if args.has("stress"):
		panel.dialogue_directory = args.stress
		id = StringName(args.get("id", "layout_stress"))
	for i in 3: await process_frame
	panel.open_conversation(id)
	for i in 4: await process_frame
	if args.has("focus_last"):
		var up := InputEventAction.new(); up.action = &"ui_up"; up.pressed = true
		root.push_input(up)
	for i in 6: await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(args.out)
	print("saved ", args.out, " window=", root.size, " visible_rect=", root.get_visible_rect().size)
	quit()
