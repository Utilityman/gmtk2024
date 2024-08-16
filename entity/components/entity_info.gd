class_name EntityInfo extends Node

signal on_entity_name_change
signal on_level_change

@export var entity_name: String:
	set(new_name):
		entity_name = new_name
		on_entity_name_change.emit(new_name)

@export var level: int:
	set(new_level):
		level = new_level
		on_level_change.emit(new_level)

func load_data (data: RpgData) -> void:
	entity_name = data.name
	level = data.level
