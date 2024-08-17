class_name Projectile3D extends Area3D

@export_category("Local Projectile Properties")
@export var local_direction: Vector3 = Vector3.ZERO
@export var local_speed: float = 15.0
@export var local_acceleration: float = 1.0
@export_enum("follow_target", "follow_direction") var local_follow_style: String = "follow_target"
@export var local_target: Vector3 = Vector3.ZERO

signal on_entity_hit
signal on_environment_hit # TBD use this eventually?

var source: Node3D
var target: Node3D: 
	set(value):
		if value is Entity: _hit_target = value.projectile_source
		else: _hit_target = value
		target = value
var _hit_target: Node3D

var data: ProjectileData
var enabled: bool = false

@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var timer: Timer = $Lifetime
@onready var visual_effects: Node3D = $VisualEffects
 
func _ready() -> void:
	if (enabled): body_entered.connect(_on_body_entered)

	if data and data.shape: collision_shape.shape = data.shape
	if data and data.life_time: 
		timer.wait_time = data.life_time
		timer.timeout.connect(_on_lifetime_timeout)
		timer.start()
	if data and data.visual_effects:
		for visual_effect: ReplicatedSceneData in data.visual_effects:
			var replicated_scene: ReplicatedScene3D = visual_effect.as_replicated_scene()
			visual_effects.add_child(replicated_scene)
			pass

func add_projectile_data (projectile_data: ProjectileData) -> void:
	data = projectile_data
	local_direction = data.direction
	if projectile_data.use_source_direction:
		local_direction = -source.global_transform.basis.z
		print(local_direction)
	local_speed = data.speed
	local_acceleration = data.acceleration
	local_follow_style = data.follow_style

func _process(delta: float) -> void:
	# update the hit target
	if (_hit_target): local_target = _hit_target.global_position

	# then update speed and direction
	local_speed += (local_acceleration * delta)
	if local_follow_style == "follow_target":
		local_direction = (local_target - global_position).normalized()

func _physics_process(delta: float) -> void:	
	# TODO: don't look_at if origin and target are the same
	# TODO: don't look when the "Up vector and direction between node origin and target are aligned"
	if not self.global_position.is_equal_approx(local_target):
		look_at(local_target)
	position += local_direction * local_speed * delta

func _on_body_entered(body: Node3D) -> void:
	# never do anything in this case
	if body == source: return

	if body is Entity:
		if data.hit_style == "any":
			on_entity_hit.emit(body)
			free_projectile()
		elif body == target:
			on_entity_hit.emit(body)
			free_projectile()
	
	# TODO: abilities that hit the ground and do something

func _on_lifetime_timeout () -> void:    
	free_projectile()

func free_projectile() -> void:
	# TODO: other sorts of behaviors such as fading out
	await get_tree().create_timer(data.time_to_free).timeout
	queue_free()


