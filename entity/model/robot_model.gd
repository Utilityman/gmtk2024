class_name RobotModel extends Node3D

@export var entity: Entity

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var animation_time: float = 0.0
var is_dead: bool = false

func _ready() -> void:
	if entity:
		entity.shoot.connect(_on_shoot)
		entity.punch.connect(_on_punch)
		entity.death.connect(_on_death)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not is_dead:
		if animation_time == 0:
			if entity.velocity == Vector3.ZERO:
				animation_player.play("CharacterArmature|Idle")
			if entity.velocity != Vector3.ZERO:
				if entity.velocity.y > 0:
					animation_player.play("CharacterArmature|Walk")
				else:
					animation_player.play("CharacterArmature|Run")
		else: animation_time = max(animation_time - delta, 0)

func _on_shoot () -> void:
	animation_player.play("CharacterArmature|Shoot")
	animation_time = animation_player.get_animation("CharacterArmature|Shoot").length

func _on_punch () -> void:
	animation_player.play("CharacterArmature|Attack")
	animation_time = animation_player.get_animation("CharacterArmature|Attack").length

func _on_death () -> void:
	is_dead = true
	animation_player.play("CharacterArmature|Dead")
	var tween: Tween = get_tree().create_tween()
	var ground_position: Vector3 = position
	ground_position.y = -0.5 # TODO: as the robot gets bigger, this 0.5 isn't going to be quite right
	tween.tween_property(self, "position", ground_position, animation_player.get_animation("CharacterArmature|Dead").length)
