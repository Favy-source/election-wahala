extends CharacterBody3D

const WALK_SPEED: float = 5.0
const RUN_SPEED: float = 8.0
const GRAVITY: float = 9.8
const MOUSE_SENSITIVITY: float = 0.003
const MIN_CAMERA_PITCH: float = -PI / 3.0 # 60 degrees down.
const MAX_CAMERA_PITCH: float = PI / 6.0 # 30 degrees up.

@onready var camera_pivot: Node3D = $CameraPivot
@onready var spring_arm: SpringArm3D = $CameraPivot/SpringArm3D

func _ready() -> void:
	# Keep the camera's collision sweep from hitting our own capsule.
	spring_arm.add_excluded_object(get_rid())
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("release_mouse"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_viewport().set_input_as_handled()
	elif event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			get_viewport().set_input_as_handled()
	elif event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		camera_pivot.rotation.y = wrapf(
			camera_pivot.rotation.y - event.screen_relative.x * MOUSE_SENSITIVITY,
			-PI, PI
		)
		spring_arm.rotation.x = clampf(
			spring_arm.rotation.x - event.screen_relative.y * MOUSE_SENSITIVITY,
			MIN_CAMERA_PITCH, MAX_CAMERA_PITCH
		)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= GRAVITY * delta

	var input_direction := Input.get_vector(
		"move_left", "move_right", "move_forward", "move_backward"
	)
	# The pivot supplies camera yaw; the arm's pitch never tilts movement.
	var movement_direction := camera_pivot.global_basis * Vector3(
		input_direction.x, 0.0, input_direction.y
	)
	movement_direction.y = 0.0
	movement_direction = movement_direction.normalized() * input_direction.length()

	var speed := WALK_SPEED
	if Input.is_action_pressed("sprint"):
		speed = RUN_SPEED

	velocity.x = movement_direction.x * speed
	velocity.z = movement_direction.z * speed

	move_and_slide()

	# Return to the platform if you fall off its edge.
	if position.y < -10.0:
		position = Vector3(0.0, 1.0, 0.0)
		velocity = Vector3.ZERO
