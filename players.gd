class_name _Players extends Node3D

var default_names: Array[String] = ['Todd', 'Aaron', 'Bernice', 'Silver', 'Netty', 'Terra', 'Dotty', 'Rusty', 'Mug', 'Rob', 'Bender', 'Atlas', 'Cyrus', 'Nico', 'Yuri', 'Zephyr', 'Ada', 'Bella', 'Eva', 'Fiona', 'Luna', 'Sol', 'Maya', 'Valentine', 'Xena']

const starting_punch: Ability = preload("res://implementation/ability/shots/punch.tres")
const starting_shot: Ability = preload("res://implementation/ability/shots/basic_shot.tres")

@export var starting_npcs: int = 19

var npcs: Array[PlayerData]
var player: PlayerData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i: int in range(starting_npcs):
		var botname: String = default_names.pick_random()
		default_names.erase(botname)

		var player_data: PlayerData = create_setup_player_data(botname)
		npcs.append(player_data)

func create_setup_player_data (player_name: String) -> PlayerData:
	var player_data: PlayerData = PlayerData.new()
	var rpg_data: RpgData = RpgData.new()
	rpg_data.name = player_name
	rpg_data.spellbook = Spellbook.new()
	rpg_data.base_stats = StatBlock.new()
	rpg_data.base_stats.hitpoints = 50

	player_data.data = rpg_data
	player_data.punch_ability = starting_punch.duplicate(true)
	player_data.shoot_ability = starting_shot.duplicate(true)

	return player_data

func setup_player (player_name: String) -> void:
	player = create_setup_player_data(player_name)

	
