extends Node3D
@export var shop_time: int = 60

@onready var timer: Timer = $Timer
@onready var timer_label: Label = $Control/Timer
@onready var arms1_button: TextureButton = $Control/Control/PanelContainer/GridContainer/Arm1
@onready var arms2_button: TextureButton = $Control/Control/PanelContainer/GridContainer/Arm1
@onready var arms3_button: TextureButton = $Control/Control/PanelContainer/GridContainer/Arm1
@onready var head1_button: TextureButton = $Control/Control/PanelContainer/GridContainer/Arm1
@onready var head2_button: TextureButton = $Control/Control/PanelContainer/GridContainer/Arm1
@onready var head3_button: TextureButton = $Control/Control/PanelContainer/GridContainer/Arm1

var player_data: PlayerData = Players.player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start(shop_time)
	print(player_data)
	# if player_data.money < 60:
	# 	arms1_button.disabled = true
	
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
	#player_data.money = player_data.money - 60
	player_data.arms = 1

func _on_head_1_pressed() -> void:
	#player_data.money = player_data.money - 60
	player_data.head = 1

func _on_arm_2_pressed() -> void:
	#player_data.money = player_data.money - 80
	player_data.arms = 2

func _on_head_2_pressed() -> void:
	#player_data.money = player_data.money - 80
	player_data.head = 2

func _on_arm_3_pressed() -> void:
	#player_data.money = player_data.money - 100
	player_data.arms = 3

func _on_head_3_pressed() -> void:
	#player_data.money = player_data.money - 100
	player_data.head = 3


