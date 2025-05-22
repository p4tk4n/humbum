extends CharacterBody3D

var speed
const WALK_SPEED := 5.0
const SPRINT_SPEED := 8.0
const JUMP_VELOCITY := 4.5
var gravity := 15.0
var sensitivity := 0.02

#head bobbing
var bobbing_freq := 1.5
var bobbing_amp := 0.12
var bobbing_t := 0.0

const BASE_FOV := 75.0
const FOV_CHANGE := 1.8

var sprint_bar_progress_speed = 20
var can_sprint = true

@onready var head = $head
@onready var camera = $head/Camera3D
@onready var sprint_bar = $hud_layer/sprint_bar_container/sprint_bar
@onready var sprint_delay_timer = $sprint_delay_timer
@onready var phone = $hud_layer/phone_container/phone
@onready var pause_menu = $hud_layer/pause_menu

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	_toggle_phone_menu()
	_toggle_pause_menu()
	
func _toggle_pause_menu(state = null):
	match state:
		"on":
			pause_menu.visible = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		"off":
			pause_menu.visible = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		_:
			pause_menu.visible = not pause_menu.visible
			if Input.MOUSE_MODE_CAPTURED:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _toggle_phone_menu(state = null):
	match state:
		"on":
			phone.visible = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		"off":
			phone.visible = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		_:
			phone.visible = not phone.visible
			if Input.MOUSE_MODE_CAPTURED:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * sensitivity)
		camera.rotate_x(-event.relative.y * sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))
		
func _physics_process(delta: float) -> void:
	#gravitacia
	if not is_on_floor():
		velocity.y -= gravity * delta

	# skakanie
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	#sprintovanie
	
	if Input.is_action_just_pressed("open_phone"):
		_toggle_phone_menu()
	
	if Input.is_action_just_pressed("ui_cancel"):
		_toggle_pause_menu()
	
	# Sprint control
	if Input.is_action_pressed("sprint") and can_sprint:
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED
	
	# Handle sprint bar filling when sprinting
	if speed > 5.0 and can_sprint:
		sprint_bar.value += delta * sprint_bar_progress_speed
		if sprint_bar.value >= sprint_bar.max_value:
			can_sprint = false  # Disable sprint when bar fills completely
	
	# Handle sprint bar depletion when not sprinting
	elif sprint_delay_timer.is_stopped():
		sprint_bar.value -= delta * sprint_bar_progress_speed
		can_sprint = true  # Allow sprinting while recharging
	
	# Start depletion delay when stopping sprint
	if Input.is_action_just_released("sprint"):
		sprint_delay_timer.start(0.5)  # Shorter 0.5s delay
	
	# Final can_sprint check
	can_sprint = can_sprint and sprint_bar.value < sprint_bar.max_value
	
	#movement
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = 0.0
			velocity.z = 0.0
	else: 
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0)
	bobbing_t += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(bobbing_t)
	
	#fov changing
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED*2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)
	
	move_and_slide()

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * bobbing_freq) * bobbing_amp
	pos.x = cos(time * bobbing_freq / 2) * bobbing_amp
	return pos

func _on_return_button_pressed() -> void:
	_toggle_pause_menu("off")

func _on_menu_button_pressed() -> void:
	global._switch_to_scene("res://main_menu/scene/main_menu.tscn")
	
func _on_exit_button_pressed() -> void:
	global._exit_game()
