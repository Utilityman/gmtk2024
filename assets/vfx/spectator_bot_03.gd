extends Node3D

var animations: Array[String] = ["CharacterArmature|Idle", "CharacterArmature|Shoot", "CharacterArmature|Jump", "CharacterArmature|Attack", "CharacterArmature|Idle"]

func _ready() -> void:
	cycle_animations()

func cycle_animations () -> void:
	$AnimationPlayer.play(animations.pick_random())
	await $AnimationPlayer.animation_finished
	await get_tree().create_timer(randf_range(0, 1.5)).timeout
	cycle_animations()
