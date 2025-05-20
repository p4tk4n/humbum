extends Node3D
#svet

func switch_to_scene(scene_path):
	FadingEffect.transition()
	await FadingEffect.on_transition_finished
	get_tree().change_scene_to_file(scene_path)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		switch_to_scene("res://main_menu/scene/main_menu.tscn")
