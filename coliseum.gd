class_name Coliseum extends Node3D

const npc_scene: PackedScene = preload("res://entity/non_player_entity.tscn")
const local_player_scene: PackedScene = preload("res://local_player_entity.tscn")
var camera_scene: PackedScene = preload("res://game/camera/observing_camera.tscn")

var player_cuttoff: int = 1

@onready var resource_label: Label = $"%ResourceCount"
@onready var goal_label: Label = $Control/GoalContainer/GoalLabel
@onready var player_label: Label = $Control/PlayerCountContainer/PlayerCountLabel

@onready var killbox: Area3D = $Killbox
@onready var spectators: Node3D = $Spectators

var players_remaining: int

var set_look_at: bool = false
var player: Entity

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Players.times_in_arena >= Players.player_thresholds.size():
		player_cuttoff = 1
	else: player_cuttoff = Players.player_thresholds[Players.times_in_arena]

	Players.times_in_arena += 1
	setup_killbox()

	var tween: Tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(spectators, "position", Vector3(0, 8, 0), 12.0)

	var platforms: Array[Node] = get_tree().get_nodes_in_group("STARTING_PLATFORM")
	platforms = platforms.filter(func (platform: Node) -> bool: 
		var p: StartingPlatform = platform as StartingPlatform
		return p.is_active
	)
	var number_of_players: int = 1 + Players.npcs.size()
	var difference: int = platforms.size() - number_of_players

	for i in range(difference):
		var node: Node = platforms.pick_random()
		platforms.erase(node)
		node.queue_free()	

	for data: PlayerData in Players.npcs:
		var entity: Entity = npc_scene.instantiate()
		setup_and_add_entity(entity, data)

		var platform: Node3D = platforms.pick_random() as Node3D
		platforms.erase(platform)
		entity.global_position = platform.global_position + Vector3(0, 0.5, 0)

	player = local_player_scene.instantiate()
	setup_and_add_entity(player, Players.player, true) 

	var player_platform: Node3D = platforms.pick_random() as Node3D
	player.global_position = player_platform.global_position + Vector3(0, 0.5, 0)

	players_remaining = get_tree().get_node_count_in_group("ENTITY")
	for node: Node in get_tree().get_nodes_in_group("ENTITY"):
		if node is not Entity: 
			Logger.warn("Found non-player with ENTITY group tag: " + str(node))
			players_remaining -= 1
			continue
		var entity: Entity = node as Entity
		entity.death.connect(_on_entity_death)

	goal_label.text = "Survive to be in top " + str(player_cuttoff) + "!"


func setup_and_add_entity (entity: Entity, data: PlayerData, add_camera: bool = false) -> void:
	entity.robo_data = data
	entity.data = data.data
	entity.shoot_ability = data.shoot_ability
	entity.melee = data.punch_ability
	add_child(entity, true)

	var skelington: Skeleton3D = entity.model.skeleton
	entity.robo_data = data
	entity.data = data.data
	entity.shoot_ability = data.shoot_ability
	entity.melee = data.punch_ability
	# data.arms= 0
	# data.head = 3
	Players.resize_arm(entity, data, skelington)
	Players.resize_head(data, skelington)

	if add_camera:
		var camera: ObservingCamera = camera_scene.instantiate()
		entity.add_child(camera)
		camera.entity = entity

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	player_label.text = str(players_remaining) + " Players Remaining"
	resource_label.text = str("Bolts Collected: " + str(player.robo_data.money))

func _on_entity_death () -> void:
	players_remaining -= 1
	if players_remaining == player_cuttoff:
		move_to_intermission("Finish!")

func move_to_intermission (text: String) -> void:
	# TODO: stop all abilities and allow pickups for 5 seconds
	$%FinishLabel.text = text
	$%FinishLabel.visible = true
	# TODO: tween some animations and stuff
	for node: Node in get_tree().get_nodes_in_group("ENTITY"):
		if node is not Entity: 
			Logger.warn("Found non-player with ENTITY group tag: " + str(node))
			continue
		var entity: Entity = node as Entity
		if entity.stats_component.health.current == 0:
			Players.npcs.erase(entity.robo_data)

	if Players.npcs.is_empty(): 
		print("We have a winner!!!")
		# get_tree().call_deferred("change_scene_to_file", "res://winner.tscn")
	else: get_tree().call_deferred("change_scene_to_file", "res://intermission.tscn")
		
func setup_killbox() -> void:
	killbox.body_entered.connect(_on_killbox_entered)

func _on_killbox_entered (node: Node3D) -> void:
	if node is Entity:
		var entity: Entity = node as Entity
		entity._on_health_changed(0)
