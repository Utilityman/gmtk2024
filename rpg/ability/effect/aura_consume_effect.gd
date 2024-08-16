class_name AuraConsumeEffect extends _AbilityEffect

@export var apply_to_self: bool = true
@export var aura_filters: Array[AuraFilter] = []

func apply (context: EffectContext) -> void:
    var source: Entity = context.source
    var target: Entity = context.target
    var entity: Entity = target if ! apply_to_self else source

    var auras: Array[BaseAura] = entity.aura_component.get_auras().filter(func (aura: BaseAura) -> bool:
        for filter in aura_filters:
            if filter.evaluate(aura): return true
        return false
    )

    for aura: BaseAura in auras:
        entity.aura_component.remove_aura(aura)
                
