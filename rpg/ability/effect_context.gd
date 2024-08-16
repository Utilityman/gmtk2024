class_name EffectContext extends Resource

var source: Entity
var target: Entity
var source_ability: Ability
var source_aura: BaseAura

func _init(ctx_source: Entity, ctx_target: Entity) -> void:
    source = ctx_source
    target = ctx_target
