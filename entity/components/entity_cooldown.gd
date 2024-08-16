class_name EntityCooldown extends Node

signal expired

@export var id: String
@export var duration: float:
    set(value):
        duration = max(value, 0)
@export var max_duration: float

func _process(delta: float) -> void:
    if duration > 0:
        duration -= delta
    elif duration == 0:
        expired.emit(id)

func setup(ability: Ability) -> void:
    Logger.info("Creating Cooldown for: " + ability.id)
    self.name = ability.id
    id = ability.id
    max_duration = ability.cooldown
    duration = ability.cooldown