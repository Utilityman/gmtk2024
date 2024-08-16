class_name _Global extends Node

func _ready() -> void:
	setup_logger()

func setup_logger () -> void:
	# TODO: consider logging the multiplayer id
	var pid: int = OS.get_process_id()
	Logger.output_format = str(pid) + " ({TIME}) [{LVL}] {MSG}"
