class_name _Players extends Node3D

var default_names: Array[String] = ['Todd', 'Aaron', 'Bernice', 'Silver', 'Netty', 'Terra', 'Dotty', 'Rusty', 'Mug', 'Rob', 'Bender', 'Atlas', 'Cyrus', 'Nico', 'Yuri', 'Zephyr', 'Ada', 'Bella', 'Eva', 'Fiona', 'Luna', 'Sol', 'Maya', 'Valentine', 'Xena']

const starting_punch: Ability = preload("res://implementation/ability/shots/punch.tres")
const starting_shot: Ability = preload("res://implementation/ability/shots/basic_shot.tres")

@export var starting_npcs: int = 19

@export var times_in_arena: int = 0
@export var player_thresholds: Array[int] = [10, 5, 2]

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

	
func resize_arm(entity: Entity, data: PlayerData, skeleton: Skeleton3D) -> void:
	var scale: float = 0
	var collison_scale: float = 1
	if data.arms == 0:
		scale = 1
	if data.arms == 1:
		scale= 3
		collison_scale = 1.25
	if data.arms == 2:
		scale= 5
		collison_scale = 1.5
	if data.arms == 3:
		scale= 7
		collison_scale = 1.75

	var bone_index_r: int = skeleton.find_bone("Shoulder.R")
	var bone_index_l: int = skeleton.find_bone("Shoulder.L")

	var pose_r: Transform3D = skeleton.get_bone_pose(bone_index_r)
	var pose_l: Transform3D = skeleton.get_bone_pose(bone_index_l)

	pose_r = pose_r.scaled(Vector3(scale, scale, scale))
	pose_l = pose_l.scaled(Vector3(scale, scale, scale))

	skeleton.set_bone_pose(bone_index_r, pose_r)
	skeleton.set_bone_pose(bone_index_l, pose_l)

	var player_collision: CollisionShape3D= entity.get_node("Collision")

	player_collision.scale = Vector3(collison_scale, collison_scale, collison_scale)

	#Decrease hand collision shapes
	if data.arms != 0:
		var left_hand_collision: CollisionShape3D= entity.get_node("RobotModel/RootNode/CharacterArmature/Skeleton3D/BoneAttachment3D/Area3D/CollisionShape3D")
		var right_hand_collision: CollisionShape3D = entity.get_node("RobotModel/RootNode/CharacterArmature/Skeleton3D/BoneAttachment3D2/Area3D/CollisionShape3D")
		var hand_shape: SphereShape3D = left_hand_collision.shape
		hand_shape.radius = 0.0015
		left_hand_collision.shape = hand_shape
		right_hand_collision.shape = hand_shape

func resize_head(data: PlayerData, skeleton: Skeleton3D) -> void:
	var head_scale: float = 0
	var arms_scale: float = 0
	if data.head == 0:
		head_scale = 1
		arms_scale = 1
	if data.head == 1:
		head_scale= 3
		arms_scale = 0.333 
	if data.head == 2:
		head_scale= 5
		arms_scale =  0.2 
	if data.head == 3:
		head_scale= 7
		arms_scale = 0.143
	
	var bone_index: int = skeleton.find_bone("Head")
	var pose: Transform3D = skeleton.get_bone_pose(bone_index)
	pose = pose.scaled(Vector3(head_scale, head_scale, head_scale))
	skeleton.set_bone_pose(bone_index, pose)
	var bone_index_r: int = skeleton.find_bone("Shoulder.R")
	var bone_index_l: int = skeleton.find_bone("Shoulder.L")

	var pose_r: Transform3D = skeleton.get_bone_pose(bone_index_r)
	var pose_l: Transform3D = skeleton.get_bone_pose(bone_index_l)

	pose_r = pose_r.scaled(Vector3(arms_scale, arms_scale, arms_scale))
	pose_l = pose_l.scaled(Vector3(arms_scale, arms_scale, arms_scale))

	skeleton.set_bone_pose(bone_index_r, pose_r)
	skeleton.set_bone_pose(bone_index_l, pose_l)

	