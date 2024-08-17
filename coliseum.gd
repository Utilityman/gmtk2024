class_name Coliseum extends Node3D

const entity_scene: PackedScene = preload("res://entity/entity.tscn")

var npc_names: Array[String] = ["Tony the Tank"]

@export var intermission: PackedScene

@export var player_cuttoff: int = 1
@export var arena_time: int = 45

@onready var player: Entity = $Player
@onready var timer: Timer = $Timer

@onready var goal_label: Label = $Control/GoalContainer/GoalLabel
@onready var player_label: Label = $Control/PlayerCountContainer/PlayerCountLabel
@onready var timer_label: Label = $Control/Timer

var players_remaining: int

func _ready() -> void:
	# TODO: don't export number of players, and player cutoff. Get that from some other global (that is keeping track of how many times we've been to the coliseum)
	
	var platforms: Array[Node] = get_tree().get_nodes_in_group("STARTING_PLATFORM")
	var number_of_players: int = 1 + Players.npcs.size()
	print("Number of Players: " + str(number_of_players))
	var difference: int = platforms.size() - number_of_players

	for i in range(difference):
		var node: Node = platforms.pick_random()
		platforms.erase(node)
		node.queue_free()	

	for data: PlayerData in Players.npcs:
		var entity: Entity = entity_scene.instantiate()
		entity.data = data.data
		entity.shoot_ability = data.shoot_ability
		entity.melee = data.punch_ability
		add_child(entity)

		var platform: Node3D = platforms.pick_random() as Node3D
		platforms.erase(platform)

		entity.global_position = platform.global_position + Vector3(0, 0.5, 0)
		entity.global_basis = platform.global_basis

	var player_platform: Node3D = platforms.pick_random() as Node3D
	player.global_position = player_platform.global_position + Vector3(0, 0.5, 0)
	player.global_basis = player_platform.global_basis


	timer.start(arena_time)
	timer.timeout.connect(_on_timer_timeout)
	players_remaining = get_tree().get_node_count_in_group("ENTITY")
	for node: Node in get_tree().get_nodes_in_group("ENTITY"):
		if node is not Entity: 
			Logger.warn("Found non-player with ENTITY group tag: " + str(node))
			players_remaining -= 1
			continue
		var entity: Entity = node as Entity
		entity.death.connect(_on_entity_death)

	goal_label.text = "Survive to be in top " + str(player_cuttoff) + "!"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer_label.text = "%d:%02d" % [floor($Timer.time_left / 60), int($Timer.time_left) % 60]
	if timer.time_left < 30.0:
		timer_label.text = "%10.1f" % timer.time_left
	player_label.text = "Players Remaining\n  " + str(players_remaining)

func _on_timer_timeout () -> void:
	print("OUT OF TIME!")

func _on_entity_death () -> void:
	players_remaining -= 1
	if players_remaining <= player_cuttoff:
		print("END THE GAME!!!")
		
