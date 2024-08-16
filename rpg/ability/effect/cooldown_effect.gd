class_name CooldownEffect extends _AbilityEffect

@export var ability_ids: Array[String]
# TODO: export an context filter (instead of by-id - this would theoretically filter for "Fire" school'd spells)
@export var amount: float
@export var apply_to_self: bool = true

func apply (context: EffectContext) -> void:
	var source: Entity = context.source
	var target: Entity = context.target
	var entity: Entity = target if ! apply_to_self else source


	for ability_id: String in ability_ids:
		entity.cooldowns.reduce_cooldown_by_id(ability_id, amount)
