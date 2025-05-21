class_name Customer
extends Control

@export var location_text = ""
@onready var location_label = $Panel/BoxContainer/customer_location
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	if location_text:
		location_label.text = location_text
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	location_label.text = location_text
