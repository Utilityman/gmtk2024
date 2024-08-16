class_name CooldownRequisite extends AbilityRequisite

func as_message(ability: Ability) -> String:
    return ability.name + " is still on cooldown!"

func can_use_ability (source: Entity, _target: Entity, ability: Ability) -> bool:
    if not ability.off_global_cooldown and \
        source.cooldowns.global_cooldown > 0.0:
        return false
    if source.cooldowns.ability_cooldowns.has(ability.id):
        return false
    return true