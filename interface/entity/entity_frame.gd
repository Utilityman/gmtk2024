class_name EntityFrame extends Control

# TODO: should/could the HealthBarContainer entirely be its own component? 
# TODO: how to get the player's resource into the other bar

# a nice blue for friendly targets? - #47b2ea
# @export var header_color: Color

@onready var name_container: PanelContainer = $%NameContainer
@onready var name_label: Label = $%NameLabel
@onready var level_label: Label = $%LevelLabel
@onready var health_bar: TextureProgressBar = $%HealthBar
@onready var health_label: Label = $%HealthLabel

@export var entity: Entity:
	set(new_entity):
		cleanup_health()
		cleanup_info()
		entity = new_entity
		setup_info()
		setup_health()

func setup_info() -> void:
	_on_entity_name_change(entity.info.entity_name)
	entity.info.on_entity_name_change.connect(_on_entity_name_change)

	_on_level_change(entity.info.level)
	entity.info.on_level_change.connect(_on_level_change)

func cleanup_info() -> void:
	if entity:
		entity.info.on_entity_name_change.disconnect(_on_entity_name_change)
		entity.info.on_level_change.disconnect(_on_level_change)

func _on_entity_name_change (value: String) -> void:
	name_label.text = value

func _on_level_change (value: int) -> void:
	level_label.text = str(value)

func setup_health() -> void:
	_on_health_max_changed(entity.stats_component.health.value)
	_on_health_current_changed(entity.stats_component.health.current)

	entity.stats_component.health.on_current_changed.connect(_on_health_current_changed)
	entity.stats_component.health.on_value_changed.connect(_on_health_max_changed)

func cleanup_health () -> void:
	if entity:
		entity.stats_component.health.on_current_changed.disconnect(_on_health_current_changed)
		entity.stats_component.health.on_value_changed.disconnect(_on_health_max_changed)

func _on_health_current_changed (value: float) -> void:
	health_bar.value = value
	set_health_label_text()

func _on_health_max_changed (value: float) -> void:
	health_bar.max_value = value
	set_health_label_text()

func set_health_label_text () -> void:
	health_label.text = str(health_bar.value) + " / " + str(health_bar.max_value)
