class_name LineOfSightRequisite extends AbilityRequisite

func as_message (_ability: Ability) -> String:
    return 'Target not in line of sight!'

func can_use_ability (source: Entity, target: Entity, ability: Ability) -> bool:
    # Launch an amount of raycasts at the target to determine whether they're in LoS
    return source.global_position.distance_to(target.global_position) < ability.use_range