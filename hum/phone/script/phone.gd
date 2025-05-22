extends Control

@onready var taxi_app = $Panel/taxi_app_container
@onready var taxi_app_button = $Panel/apps/taxi_app

func _ready() -> void:
	taxi_app.visible = false

func _on_taxi_app_pressed() -> void:
	taxi_app.visible = true
	taxi_app_button.visible = false

func _on_home_button_app_pressed() -> void:
	taxi_app.visible = false
	taxi_app_button.visible = true
