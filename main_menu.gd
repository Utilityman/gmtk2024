extends Control

@export var game_scene: PackedScene

@onready var start_button: Button = $VBoxContainer/Start
@onready var credits_button: Button = $VBoxContainer/Credits
@onready var name_field: LineEdit = $VBoxContainer/HBoxContainer/NameField

@onready var explosion1: PlatformExplosion = $Background/Explosion1
@onready var explosion2: PlatformExplosion = $Background/Explosion2

var player_data :PlayerData = Players.player

func _ready() -> void:
	Players.load()
	Players.times_in_arena = 0

	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	start_button.pressed.connect(_on_start)
	credits_button.pressed.connect(_on_credits)
	
	random_explode(explosion1)
	random_explode(explosion2)

func random_explode (explosion: PlatformExplosion) -> void:
	var timer: SceneTreeTimer = get_tree().create_timer(randi() % 8)
	timer.timeout.connect(
		func() -> void: 
			explosion.explode()
			random_explode(explosion)
	)

func _on_start () -> void:
	var player_name: String = name_field.text if name_field.text != "" else "_blank"
	Players.setup_player(player_name)

	SceneTransition.call_deferred("change_scene_to_packed", game_scene)

func _on_credits () -> void:
	SceneTransition.call_deferred("change_scene_to_file", "res://credits.tscn")

