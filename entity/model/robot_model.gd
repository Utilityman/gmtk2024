class_name RobotModel extends Node3D

@export var entity: Entity

@onready var animation_player: AnimationPlayer = $AnimationPlayer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if entity.velocity == Vector3.ZERO:
		animation_player.play("CharacterArmature|Idle")
	if entity.velocity != Vector3.ZERO:
		if entity.velocity.y > 0:
			animation_player.play("CharacterArmature|Walk")
		else:
			animation_player.play("CharacterArmature|Run")

