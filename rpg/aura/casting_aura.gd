class_name CastingAura extends BaseAura

var target: Entity
var ability: Ability

func load(src: Entity, tar: Entity, abi: Ability) -> void:
	source = src
	target = tar
	ability = abi
	duration = ability.cast_time

func on_end () -> void:
	super.on_end()
	source.activate_ability(ability, target)
