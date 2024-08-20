extends Control

@onready var quit: Button = $"%Quit"

func _ready() -> void:
	self.visible = false
	quit.pressed.connect(_on_quit_pressed)

func _on_quit_pressed () -> void:
	get_tree().paused = false
	SceneTransition.call_deferred("change_scene_to_file", "res://main_menu.tscn")