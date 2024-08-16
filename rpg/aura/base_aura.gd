class_name BaseAura extends Resource

# TODO: do I want to send signals out on different states here?
# TODO: a lot of potential visual stuff could maybe be in here
# TODO: compound auras (a Shield that provides damage reduction)

# TODO: both Ability and Aura have the same sort of id, name, description, icon

@export var id: String

@export_category("Description")
@export var name: String
@export_multiline var description: String
@export var icon: Texture2D

@export_category("Data")
@export_range(0.0, 24.0, 0.5, "or_greater") var duration: float
@export var forever: bool = false
@export_enum("none", "spell_cast", "feature", "buff", "debuff") var type: String
@export_enum("magic", "curse", "disease", "bleed", "enrage") var sub_type: String

@export_category("Uniqueness")
@export_enum("by_entity", "by_aura", "no") var is_unique: String = "by_entity"
@export var max_stacks: int = 1

var source: Entity
# TBD stacks

# @export_enum("magic", "curse", "disease", "bleed", "enrage") var sub_types: Array[String] # TODO: Godot 4.3

var _max_duration: float = -1.0

func on_start () -> void: pass
func on_end () -> void: pass

func update(delta: float) -> void:
	# TODO: a better way of setting the _max_duration? 
	if _max_duration == -1.0: _max_duration = duration
	duration = max(duration - delta, 0)

func is_complete () -> bool:
	return duration == 0

func refresh () -> void:
	add_duration(_max_duration)

func add_duration (duration_to_add: float) -> void:
	duration = min(duration + duration_to_add, _max_duration + 1.5 * 4)
