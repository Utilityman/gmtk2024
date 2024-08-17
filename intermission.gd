extends Node3D
@export var shop_time: int = 60

@onready var timer: Timer = $Timer
@onready var timer_label: Label = $Control/Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start(shop_time)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer_label.text = "%d:%02d" % [floor($Timer.time_left / 60), int($Timer.time_left) % 60]
	if timer.time_left < 30.0:
		timer_label.text = "%10.1f" % timer.time_left

func _on_timer_timeout () -> void:
	print("OUT OF TIME IN SHOP!")

func _on_texture_button_pressed() -> void :
	print("clicked")


func _on_continue_button_pressed() -> void :
	get_tree().change_scene_to_file("res://coliseum.tscn")
