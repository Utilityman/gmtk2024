class_name SpellKnownRequisite extends AbilityRequisite

func as_message (ability: Ability) -> String:
	return ability.name + " isn't known!"

func can_use_ability (source: Entity, _target: Entity, ability: Ability) -> bool:
	return source.spellbook.has_learned(ability)
