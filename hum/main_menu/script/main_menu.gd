extends Node2D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func switch_to_scene(scene_path):
	FadingEffect.transition()
	await FadingEffect.on_transition_finished
	get_tree().change_scene_to_file(scene_path)

func _on_play_button_pressed() -> void:
	switch_to_scene("res://world/scene/world.tscn")

func _on_exit_button_pressed() -> void:
	get_tree().quit()
