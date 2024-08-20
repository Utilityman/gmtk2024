extends Node3D
@export var shop_time: int = 60

@onready var timer: Timer = $Timer
@onready var timer_label: Label = $Control/Timer
@onready var arms1_button: Button = $Control/PanelContainer/GridContainer/Arm1
@onready var arms2_button: Button = $Control/PanelContainer/GridContainer/Arm2
@onready var arms3_button: Button = $Control/PanelContainer/GridContainer/Arm3
@onready var head1_button: Button = $Control/PanelContainer/GridContainer/Head1
@onready var head2_button: Button = $Control/PanelContainer/GridContainer/Head2
@onready var head3_button: Button = $Control/PanelContainer/GridContainer/Head3
@onready var player_body: Skeleton3D = $Player/RobotModel/RootNode/CharacterArmature/Skeleton3D
@onready var player_collision: CollisionShape3D = $Player/Collision
@onready var player: Entity= $Player
# @onready var left_hand_collision : CollisionShape3D = $Player/RobotModel/RootNode/CharacterArmature/Skeleton3D/BoneAttachment3D/Area3D/CollisionShape3D
# @onready var right_hand_collision : CollisionShape3D = $Player/RobotModel/RootNode/CharacterArmature/Skeleton3D/BoneAttachment3D2/Area3D/CollisionShape3D
@onready var screws: GPUParticles3D = $Screws/GPUParticles3D

var player_data: PlayerData = Players.player
var target_scale: Vector3 = Vector3(2, 2, 2)

const punch_v2: Ability = preload("res://implementation/ability/shots/punch_v2.tres")
const punch_v3: Ability = preload("res://implementation/ability/shots/punch_v3.tres")
const punch_v4: Ability = preload("res://implementation/ability/shots/punch_v4.tres")
const shot_v2: Ability = preload("res://implementation/ability/shots/basic_shot_v2.tres")
const shot_v3: Ability = preload("res://implementation/ability/shots/basic_shot_v3.tres")
const shot_v4: Ability = preload("res://implementation/ability/shots/basic_shot_v4.tres")

@onready var entity: Entity = $Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	timer.start(shop_time)
	player_data.money = 1000
	Players.resize_arm(player, player_data, player_body)
	Players.resize_head(player_data, player_body)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer_label.text = "%d:%02d" % [floor($Timer.time_left / 60), int($Timer.time_left) % 60]
	if timer.time_left < 30.0:
		timer_label.text = "%10.1f" % timer.time_left
	if player_data.money < 60 or player_data.arms >= 1:
		arms1_button.disabled = true
	if player_data.money < 60 or player_data.head >=1 :
		head1_button.disabled = true
	if player_data.money < 70 or player_data.arms != 1:
		arms2_button.disabled = true
	if player_data.money < 70 or player_data.head != 1:
		head2_button.disabled = true
	if player_data.money < 80 or player_data.arms != 2:
		arms3_button.disabled = true
	if player_data.money < 80 or  player_data.head != 2:
		head3_button.disabled = true

func _on_timer_timeout() -> void:
	print("OUT OF TIME IN SHOP!")
	get_tree().change_scene_to_file("res://coliseum.tscn")

func _on_texture_button_pressed() -> void:
	print("clicked")


func _on_continue_button_pressed() -> void:
	get_tree().change_scene_to_file("res://coliseum.tscn")

#all money values are hard coded rn and super made up
func _on_arm_v2_pressed() -> void:
	# this is the stuff that needs to happen, all else is visuals and such
	player_data.money = player_data.money - 60
	player_data.punch_ability = punch_v2
	player_data.arms = 1
	player_data.data.base_stats.hitpoints += 100

	print("purchased arms vo. 2")
	screws.emitting = true
	entity.melee = punch_v2


	var bone_index_r: int = player_body.find_bone("Shoulder.R")
	var bone_index_l: int = player_body.find_bone("Shoulder.L")

	var pose_r: Transform3D = player_body.get_bone_pose(bone_index_r)
	var pose_l: Transform3D = player_body.get_bone_pose(bone_index_l)

	var scl: int = 3
	pose_r = pose_r.scaled(Vector3(scl, scl, scl))
	pose_l = pose_l.scaled(Vector3(scl, scl, scl))

	player_body.set_bone_pose(bone_index_r, pose_r)
	player_body.set_bone_pose(bone_index_l, pose_l)

	#Increase collision shape here
	var collison_scale: float = 1.25 
	player_collision.scale = Vector3(collison_scale, collison_scale, collison_scale)

	#Decrease hand collision shapes

	# var hand_shape: SphereShape3D = left_hand_collision.shape
	# hand_shape.radius = 0.0015
	# left_hand_collision.shape = hand_shape
	# right_hand_collision.shape = hand_shape
	arms1_button.disabled = true
	arms2_button.disabled = false

func _on_head_1_pressed() -> void:
	player_data.money = player_data.money - 60
	player_data.head = 1

	player_data.shoot_ability = shot_v2
	player_data.data.base_stats.hitpoints += 100
	entity.shoot_ability = shot_v2


	screws.emitting = true
	var head_scale: int = 3
	var bone_index: int = player_body.find_bone("Head")
	var pose: Transform3D = player_body.get_bone_pose(bone_index)
	pose = pose.scaled(Vector3(head_scale, head_scale, head_scale))
	player_body.set_bone_pose(bone_index, pose)
	var arms_scale: float = 0.3333
	var bone_index_r: int = player_body.find_bone("Shoulder.R")
	var bone_index_l: int = player_body.find_bone("Shoulder.L")

	var pose_r: Transform3D = player_body.get_bone_pose(bone_index_r)
	var pose_l: Transform3D = player_body.get_bone_pose(bone_index_l)

	pose_r = pose_r.scaled(Vector3(arms_scale, arms_scale, arms_scale))
	pose_l = pose_l.scaled(Vector3(arms_scale, arms_scale, arms_scale))

	player_body.set_bone_pose(bone_index_r, pose_r)
	player_body.set_bone_pose(bone_index_l, pose_l)
	
	head1_button.disabled = true
	head2_button.disabled = false

func _on_arm_2_pressed() -> void:
	player_data.money = player_data.money - 80
	player_data.arms = 2
	player_data.punch_ability = punch_v3
	player_data.data.base_stats.hitpoints += 100
	entity.melee = punch_v3
	screws.emitting = true
	print("purchased arms vo. 3")
	var bone_index_r: int = player_body.find_bone("Shoulder.R")
	var bone_index_l: int = player_body.find_bone("Shoulder.L")

	var pose_r: Transform3D = player_body.get_bone_pose(bone_index_r)
	var pose_l: Transform3D = player_body.get_bone_pose(bone_index_l)

	var scale: float = 1.67
	pose_r = pose_r.scaled(Vector3(scale, scale, scale))
	pose_l = pose_l.scaled(Vector3(scale, scale, scale))

	player_body.set_bone_pose(bone_index_r, pose_r)
	player_body.set_bone_pose(bone_index_l, pose_l)

	var collison_scale: float = 1.5
	player_collision.scale = Vector3(collison_scale, collison_scale, collison_scale)

	arms2_button.disabled = true
	arms3_button.disabled = false
		

func _on_head_2_pressed() -> void:
	player_data.money = player_data.money - 60
	player_data.head = 2
	screws.emitting = true
	player_data.shoot_ability = shot_v3
	player_data.data.base_stats.hitpoints += 100
	entity.shoot_ability = shot_v3
	var head_scale: float = 1.67
	var bone_index: int = player_body.find_bone("Head")
	var pose: Transform3D = player_body.get_bone_pose(bone_index)
	pose = pose.scaled(Vector3(head_scale, head_scale, head_scale))
	player_body.set_bone_pose(bone_index, pose)
	var arms_scale: float = 0.599
	var bone_index_r: int = player_body.find_bone("Shoulder.R")
	var bone_index_l: int = player_body.find_bone("Shoulder.L")

	var pose_r: Transform3D = player_body.get_bone_pose(bone_index_r)
	var pose_l: Transform3D = player_body.get_bone_pose(bone_index_l)

	pose_r = pose_r.scaled(Vector3(arms_scale, arms_scale, arms_scale))
	pose_l = pose_l.scaled(Vector3(arms_scale, arms_scale, arms_scale))

	player_body.set_bone_pose(bone_index_r, pose_r)
	player_body.set_bone_pose(bone_index_l, pose_l)
	
	head2_button.disabled = true
	head3_button.disabled = false
	

func _on_arm_3_pressed() -> void:
	player_data.money = player_data.money - 100
	player_data.arms = 3
	screws.emitting = true

	player_data.punch_ability = punch_v4
	player_data.data.base_stats.hitpoints += 100
	entity.melee = punch_v4


	print("purchased arms vo. 4")
	var bone_index_r: int = player_body.find_bone("Shoulder.R")
	var bone_index_l: int = player_body.find_bone("Shoulder.L")

	var pose_r: Transform3D = player_body.get_bone_pose(bone_index_r)
	var pose_l: Transform3D = player_body.get_bone_pose(bone_index_l)

	var scale: float = 1.44
	pose_r = pose_r.scaled(Vector3(scale, scale, scale))
	pose_l = pose_l.scaled(Vector3(scale, scale, scale))

	player_body.set_bone_pose(bone_index_r, pose_r)
	player_body.set_bone_pose(bone_index_l, pose_l)

	var collison_scale: float = 1.75
	player_collision.scale = Vector3(collison_scale, collison_scale, collison_scale)
	arms3_button.disabled = true

func _on_head_3_pressed() -> void:
	player_data.money = player_data.money - 100
	player_data.head = 3
	screws.emitting = true
	player_data.shoot_ability = shot_v4
	player_data.data.base_stats.hitpoints += 100
	entity.shoot_ability = shot_v4
	var head_scale: float = 1.44
	var bone_index: int = player_body.find_bone("Head")
	var pose: Transform3D = player_body.get_bone_pose(bone_index)
	pose = pose.scaled(Vector3(head_scale, head_scale, head_scale))
	player_body.set_bone_pose(bone_index, pose)
	var arms_scale: float = 0.694
	var bone_index_r: int = player_body.find_bone("Shoulder.R")
	var bone_index_l: int = player_body.find_bone("Shoulder.L")

	var pose_r: Transform3D = player_body.get_bone_pose(bone_index_r)
	var pose_l: Transform3D = player_body.get_bone_pose(bone_index_l)

	pose_r = pose_r.scaled(Vector3(arms_scale, arms_scale, arms_scale))
	pose_l = pose_l.scaled(Vector3(arms_scale, arms_scale, arms_scale))

	player_body.set_bone_pose(bone_index_r, pose_r)
	player_body.set_bone_pose(bone_index_l, pose_l)
	
	head3_button.disabled = true
	