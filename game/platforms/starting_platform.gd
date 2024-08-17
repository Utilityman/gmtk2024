class_name StartingPlatform extends Node3D

@export var approach_direction: Vector3 = Vector3.ZERO
@export var speed: float = 1.0
@export var life_time: float = 15.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	global_position += approach_direction * speed * delta
	life_time = max(life_time - delta, 0)
	print("Lifetime: " + str(life_time))
	if life_time == 0:
		visible = false

