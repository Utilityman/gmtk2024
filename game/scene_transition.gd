class_name _SceneTransition extends CanvasLayer

func change_scene_to_packed (scene: PackedScene) -> void:
	$AnimationPlayer.play(&"dissolve")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_packed(scene)
	$AnimationPlayer.play_backwards(&"dissolve")

func change_scene_to_file (file: String) -> void:
	$AnimationPlayer.play(&"dissolve")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(file)
	$AnimationPlayer.play_backwards(&"dissolve")
	
