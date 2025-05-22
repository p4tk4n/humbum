extends Node

var player_score = 5

func _exit_game():
	get_tree().quit()

func _switch_to_scene(scene_path):
	FadingEffect.transition()
	await FadingEffect.on_transition_finished
	get_tree().change_scene_to_file(scene_path)
