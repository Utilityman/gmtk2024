class_name AuraExistsRequisite extends AbilityRequisite

@export var check_self: bool = true
@export var aura_filters: Array[AuraFilter] = []

func as_message (_ability: Ability) -> String:
    return 'I can\'t use this yet!'

func can_use_ability(source: Entity, target: Entity, _ability: Ability) -> bool:
    var entity: Entity = target if ! check_self else source

    # if any filter returns true, then we're good to go
    var evaluation: bool = false
    for aura in entity.aura_component.get_auras():
        for filter in aura_filters:
            evaluation = evaluation || filter.evaluate(aura)

    return evaluation