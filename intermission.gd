extends Node3D
@export var shop_time: int = 60

@onready var timer: Timer = $Timer
@onready var timer_label: Label = $Control/Timer
@onready var arms1_button: TextureButton = $Control/PanelContainer/GridContainer/Arm1
@onready var arms2_button: TextureButton = $Control/PanelContainer/GridContainer/Arm2
@onready var arms3_button: TextureButton = $Control/PanelContainer/GridContainer/Arm3
@onready var head1_button: TextureButton = $Control/PanelContainer/GridContainer/Head1
@onready var head2_button: TextureButton = $Control/PanelContainer/GridContainer/Head2
@onready var head3_button: TextureButton = $Control/PanelContainer/GridContainer/Head3
@onready var player_body: Skeleton3D = $Player/RobotModel/RootNode/CharacterArmature/Skeleton3D

var player_data: PlayerData = Players.player
var target_scale: Vector3 = Vector3(2, 2, 2)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start(shop_time)
	print(player_data)
	print(player_body)
	if player_data.money < 60 or player_data.arms == 1:
		arms1_button.disabled = true
	if player_data.money < 60:
		head1_button.disabled = true
	if player_data.money < 70:
		arms2_button.disabled = true
	if player_data.money < 70:
		head2_button.disabled = true
	if player_data.money < 80:
		arms3_button.disabled = true
	if player_data.money < 80:
		head3_button.disabled = true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer_label.text = "%d:%02d" % [floor($Timer.time_left / 60), int($Timer.time_left) % 60]
	if timer.time_left < 30.0:
		timer_label.text = "%10.1f" % timer.time_left

func _on_timer_timeout() -> void:
	print("OUT OF TIME IN SHOP!")
	get_tree().change_scene_to_file("res://coliseum.tscn")

func _on_texture_button_pressed() -> void:
	print("clicked")


func _on_continue_button_pressed() -> void:
	get_tree().change_scene_to_file("res://coliseum.tscn")

#all money values are hard coded rn and super made up
func _on_arm_v2_pressed() -> void:
	print("purchased arms vo. 2")
	player_data.money = player_data.money - 60
	player_data.arms = 1
	var bone_index_r: int = player_body.find_bone("Shoulder.R")
	var bone_index_l: int = player_body.find_bone("Shoulder.L")

	var pose_r: Transform3D = player_body.get_bone_pose(bone_index_r)
	var pose_l: Transform3D = player_body.get_bone_pose(bone_index_l)

	var scale: int = 3
	pose_r = pose_r.scaled(Vector3(scale, scale, scale))
	pose_l = pose_l.scaled(Vector3(scale, scale, scale))

	player_body.set_bone_pose(bone_index_r, pose_r)
	player_body.set_bone_pose(bone_index_l, pose_l)

	arms1_button.disabled = true
	

func _on_head_1_pressed() -> void:
	player_data.money = player_data.money - 60
	player_data.head = 1
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
	
	
	
		


func _on_arm_2_pressed() -> void:
	player_data.money = player_data.money - 80
	player_data.arms = 2
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

	arms2_button.disabled = true
	

func _on_head_2_pressed() -> void:
	player_data.money = player_data.money - 60
	player_data.head = 1
	var head_scale: int = 1.67
	var bone_index: int = player_body.find_bone("Head")
	var pose: Transform3D = player_body.get_bone_pose(bone_index)
	pose = pose.scaled(Vector3(head_scale, head_scale, head_scale))
	player_body.set_bone_pose(bone_index, pose)
	var arms_scale: float = 0.2
	var bone_index_r: int = player_body.find_bone("Shoulder.R")
	var bone_index_l: int = player_body.find_bone("Shoulder.L")

	var pose_r: Transform3D = player_body.get_bone_pose(bone_index_r)
	var pose_l: Transform3D = player_body.get_bone_pose(bone_index_l)

	pose_r = pose_r.scaled(Vector3(arms_scale, arms_scale, arms_scale))
	pose_l = pose_l.scaled(Vector3(arms_scale, arms_scale, arms_scale))

	player_body.set_bone_pose(bone_index_r, pose_r)
	player_body.set_bone_pose(bone_index_l, pose_l)
	
	
	head1_button.disabled = true
	

func _on_arm_3_pressed() -> void:
	player_data.money = player_data.money - 100
	player_data.arms = 3

func _on_head_3_pressed() -> void:
	player_data.money = player_data.money - 100
	player_data.head = 3
