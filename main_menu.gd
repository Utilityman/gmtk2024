extends Control

@export var address: String = "127.0.0.1"
@export var port: int = 8910


var warrior: String = "res://implementation/hero/warrior_hero_definition.tres"
var cleric: String = "res://implementation/hero/cleric_hero_definition.tres"

@export var hero_data_path: String = warrior

@onready var host_button: Button = $VBoxContainer/HBoxContainer/Host
@onready var join_button: Button = $VBoxContainer/HBoxContainer/Join
@onready var log_players: Button = $VBoxContainer/LogPlayers

@onready var warrior_button: Button = $VBoxContainer/ClassChoice/Warrior
@onready var cleric_button: Button = $VBoxContainer/ClassChoice/Cleric


@onready var name_field: LineEdit = $VBoxContainer/NameField

var default_names: Array[String] = ['Josh', 'Julia', 'Arnold', 'Bernice', 'Cathe', 'Dennis', 'Earl', 'Franz', 'Gerrard', 'Hilda']

func _ready() -> void:
	warrior_button.button_down.connect(func () -> void: hero_data_path = warrior)
	cleric_button.button_down.connect(func () -> void: hero_data_path = cleric)

	host_button.button_down.connect(_on_host_button_down)
	join_button.button_down.connect(_on_join_button_down)
	log_players.button_down.connect(_on_log_players_button_down)

	multiplayer.connected_to_server.connect(on_connect_to_server)
	name_field.text = default_names.pick_random()

func _on_log_players_button_down () -> void:
	if MultiplayerManager.users.get_children().is_empty(): Logger.info("No Players in Multiplayer Manager!")
	for user: MultiplayerUser in MultiplayerManager.users.get_children():
		Logger.info("User: " + user.name + " State: " + user.state + " Data: " + str(user.hero_data))
		if user.hero_data: Logger.info("Name: " + user.hero_data.name)

func start_game () -> void: 
	var scene: PackedScene = load("res://world/dev_island.tscn")
	get_tree().change_scene_to_packed(scene)

func _on_host_button_down() -> void:
	Logger.info('Host!')
	MultiplayerManager.host_game(port)

	create_player_data()
	start_game()
	
func _on_join_button_down() -> void:
	Logger.info('Joining!')
	MultiplayerManager.join_game(address, port)

func on_connect_to_server () -> void:
	Logger.info('Main Menu handling server connection!')

	# this causes big crashing, which I'm not a fan of
	# await get_tree().create_timer(1).timeout

	create_player_data()
	start_game()

func create_player_data () -> void:
	var params: Dictionary = {
		id = multiplayer.get_unique_id(),
		player_name = name_field.text,
		hero_definition = hero_data_path
	}

	MultiplayerManager.create_new_player.rpc_id(1, params)
