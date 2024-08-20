extends Node3D

@onready var return_button: Button = $"%ReturnButton"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	return_button.pressed.connect(_on_return_pressed)

func _on_return_pressed () -> void:
	SceneTransition.call_deferred("change_scene_to_file", "res://main_menu.tscn")
