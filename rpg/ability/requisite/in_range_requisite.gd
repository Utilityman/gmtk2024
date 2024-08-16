class_name InRangeRequisite extends AbilityRequisite

func as_message (_ability: Ability) -> String:
    return 'Not in range!'

func can_use_ability (source: Entity, target: Entity, ability: Ability) -> bool:
    return source.global_position.distance_to(target.global_position) < ability.use_range