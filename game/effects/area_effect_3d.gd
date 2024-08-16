class_name AreaEffect3D extends Area3D

@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var free: bool = false

# by default the area_effect only lasts a single frame then frees itself - TODO if this needs to change
func _physics_process(_delta: float) -> void:
	if free: queue_free()
	if not free: free = true