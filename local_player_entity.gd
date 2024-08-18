class_name LocalPlayerEntity extends Entity

# @export var shoot_ability: Ability
# @export var melee: Ability

func should_jump() -> bool:
	return Input.is_action_just_pressed(&"JUMP")

func get_direction() -> Vector3:
	var input_dir: Vector2 = Input.get_vector(
		&"MOVE_LEFT", &"MOVE_RIGHT", &"MOVE_FORWARD", &"MOVE_BACK"
	)
	return (global_transform.basis * Vector3(input_dir.x, 0.0, input_dir.y)).normalized()

func get_rotate_direction() -> float:
	var rotate_dir: float = 0.0
	if Input.is_action_pressed(&"ROTATE_LEFT"):
		rotate_dir += 1.0
	if Input.is_action_pressed(&"ROTATE_RIGHT"):
		rotate_dir -= 1.0
	return rotate_dir

func _process(delta: float) -> void:
	super._process(delta)
	if Input.is_action_just_pressed("SHOOT_GUN") and cooldowns.global_cooldown == 0:
		use_ability(shoot_ability, self)
		shoot.emit()
	if Input.is_action_just_pressed("MELEE") and cooldowns.global_cooldown == 0:
		use_ability(melee, self)
		print("smack a bro")
		punch.emit()
