class_name LocalPlayerEntity extends Entity

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

# func _process(delta):
# 	if Input.is_action_just_pressed("SHOOT_GUN"):
# 		use_ability()
# 	if Input.is_action_just_pressed("SWORD"):
# 		#use_ability(sword_ability)
# 		print("swing sword")

