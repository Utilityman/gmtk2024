class_name StartingPlatform extends Node3D

const explosion: PackedScene = preload("res://assets/vfx/platform_explosion.tscn")
const rotation_shake: ShakerTypeRandom3D = preload("res://game/platforms/starting_platform_rotation_shake.tres")

# TODO: I want a shader to slowly color the model red until it explodes
# TODO: want to actually queue free the platform after the explosion animation plays

@export var is_active: bool = true
@export var approach_direction: Vector3 = Vector3.ZERO
@export var speed: float = 1.0
@export var life_time: float = 15.0

@onready var model: Node3D = $RootNode
@onready var platform_collider: StaticBody3D = $NavigationRegion3D/PlatformCollider
@onready var platform_area: Area3D = $Area3D
@onready var exploision_point: Node3D = $ExplosionPoint
@onready var shaker_timer: Timer = $ShakerTimer
@onready var explosion_timer: Timer = $ExplosionTimer
@onready var rotation_shaker: ShakerComponent3D = $RotationalShaker

var captured_nodes: Array[Node3D] = []

var started_destruction: bool = false

func _ready() -> void:
	platform_area.body_entered.connect(_on_body_entered)
	platform_area.body_exited.connect(_on_body_exited)
	shaker_timer.start(life_time - 3.0)
	shaker_timer.timeout.connect(_on_shaker_timeout)
	explosion_timer.start(life_time - 0.5)
	explosion_timer.timeout.connect(_on_explosion_timeout)

func _physics_process(delta: float) -> void:
	var movement: Vector3 = approach_direction * speed * delta
	global_position += movement
	for node: Node3D in captured_nodes:
		node.global_position += movement

	life_time = max(life_time - delta, 0)
	if life_time == 0 and not started_destruction:
		started_destruction = true
		model.visible = false
		platform_collider.queue_free()


func _on_shaker_timeout () -> void:
	rotation_shaker.play_shake()

func _on_explosion_timeout () -> void:
	var instance: Node3D = explosion.instantiate()
	exploision_point.add_child(instance)

func _on_body_entered (node: Node3D) -> void:
	captured_nodes.append(node)

func _on_body_exited (node: Node3D) -> void:
	captured_nodes.erase(node)

