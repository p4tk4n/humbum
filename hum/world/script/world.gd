extends Node3D
#svet
@onready var pause_menu = $pause_menu

func _ready():
	pause_menu.visible = false

func _switch_to_scene(scene_path):
	FadingEffect.transition()
	await FadingEffect.on_transition_finished
	get_tree().change_scene_to_file(scene_path)

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
				
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		_toggle_pause_menu()
	
func _on_return_button_pressed() -> void:
	_toggle_pause_menu("off")

func _on_exit_button_pressed() -> void:
	_switch_to_scene("res://main_menu/scene/main_menu.tscn")
