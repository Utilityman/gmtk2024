extends Control

@onready var position_label: Label = $"%PositionLabel"
@onready var quit: Button = $"%Quit"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	position_label.text = "You made it to the top: " + str(Players.npcs.size() + 1)
	quit.pressed.connect(_on_quit_pressed)

func _on_quit_pressed () -> void:
	get_tree().paused = false
	SceneTransition.call_deferred("change_scene_to_file", "res://main_menu.tscn")