extends RigidBody3D

@export var origin_entity: Entity

@onready var area3d: Area3D = $Area3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	apply_central_force(Vector3(randi() % 500 - 250, randi() % 150 + 150.0, randi() % 500 - 250))
	area3d.body_entered.connect(_on_body_entered)

func _on_body_entered (body: Node3D) -> void:
	if body == origin_entity: return
	if body is Entity:
		var entity: Entity = body as Entity
		entity.robo_data.money += 1
		queue_free()
