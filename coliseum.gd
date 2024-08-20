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

const punch_v2: Ability = preload("res://implementation/ability/shots/punch_v2.tres")
const punch_v3: Ability = preload("res://implementation/ability/shots/punch_v3.tres")
const punch_v4: Ability = preload("res://implementation/ability/shots/punch_v4.tres")
const shot_v2: Ability = preload("res://implementation/ability/shots/basic_shot_v2.tres")
const shot_v3: Ability = preload("res://implementation/ability/shots/basic_shot_v3.tres")
const shot_v4: Ability = preload("res://implementation/ability/shots/basic_shot_v4.tres")


var players_remaining: int
var set_look_at: bool = false
var player: Entity
var changing_to_intermission: bool = false

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

	_ai_decisions_upgrades(entity,data,add_camera)
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
	if not changing_to_intermission and player.stats_component.health.current == 0:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		$"%PauseMenu".disabled = true
		$"%LoseMenu".visible = true
		return
	if players_remaining == player_cuttoff:
		move_to_intermission("Finish!")

func move_to_intermission (text: String) -> void:
	changing_to_intermission = true
	for node: Node in get_tree().get_nodes_in_group("ENTITY"):
		if node is not Entity: 
			Logger.warn("Found non-player with ENTITY group tag: " + str(node))
			continue
		var entity: Entity = node as Entity
		if entity.stats_component.health.current == 0:
			Players.npcs.erase(entity.robo_data)

	if Players.npcs.is_empty(): 
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		$"%PauseMenu".disabled = true
		$"%WinnerMenu".visible = true
	else: 
		$"%PauseMenu".disabled = true
		$"%FinishLabel".visible = true
		await get_tree().create_timer(5.0).timeout
		SceneTransition.call_deferred("change_scene_to_file", "res://intermission.tscn")
		
func setup_killbox() -> void:
	killbox.body_entered.connect(_on_killbox_entered)

func _on_killbox_entered (node: Node3D) -> void:
	if node is Entity:
		var entity: Entity = node as Entity
		entity._on_health_changed(0)

func _ai_decisions_upgrades(entity: Entity, data: PlayerData, add_camera: bool = false) -> void:
	if add_camera != true:
		randomize()
		# var money_amount:int = randi() % 2 + 1 
		# var min_value: int  = 10
		# var max_value: int  = 40
		# var random_number: int = randi_range(min_value, max_value)
		# data.money += random_number

		var choice:int = randi() % 2 + 1 


		if data.money <= 19 and data.money > 9:
			if(choice == 1):
				data.arms = 1
			else:
				data.head = 1
		elif data.money <=29 and data.money > 19:
			if(choice == 1):
				data.arms = 1
				data.head = 1
			else:
				var choice2:int = randi() % 2 + 1 
				if choice2:
					data.arms = 2
				else:
					data.head = 2
		elif data.money <= 59 and data.money > 40:
			if(choice == 1):
				data.arms = 2
				data.head = 1
			else:
				data.head = 2
				data.arms = 1
		elif data.money <=95 and data.money > 59:
			if(choice == 1):
				data.arms = 2
				data.head = 2
			else:
				data.head = 2
				data.arms = 2
		elif data.money <=129 and data.money > 95:
			if(choice == 1):
				data.arms = 3
				data.head = 2
			else:
				data.head = 3
				data.arms = 2
		if data.money > 129:
			if(choice == 1):
				data.arms = 3
				data.head = 3
			else:
				data.head = 3
				data.arms = 3
		if(data.head == 1):
			data.shoot_ability = shot_v2
			entity.shoot_ability = shot_v2
			data.data.base_stats.hitpoints += 100
		if(data.arms == 1):
			data.punch_ability = punch_v2
			entity.melee = punch_v2
			data.data.base_stats.hitpoints += 100
		if(data.head == 2):
			data.shoot_ability = shot_v3
			entity.shoot_ability = shot_v3
			data.data.base_stats.hitpoints += 200
		if(data.arms == 2):
			data.punch_ability = punch_v3
			entity.melee = punch_v3
			data.data.base_stats.hitpoints += 200
		if(data.head == 3):
			data.shoot_ability = shot_v4
			entity.shoot_ability = shot_v4
			data.data.base_stats.hitpoints += 300
		if(data.arms == 3):
			data.punch_ability = punch_v4
			entity.melee = punch_v4
			data.data.base_stats.hitpoints += 300
		entity.stats_component.health.current -= 999999
