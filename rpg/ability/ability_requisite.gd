class_name AbilityRequisite extends Resource

func as_message (_ability: Ability) -> String:
    return ''

func can_use_ability (_source: Entity, _target: Entity, _ability: Ability) -> bool:
    return false