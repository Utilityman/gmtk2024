class_name AuraEffect extends _AbilityEffect

@export var auras: Array[BaseAura]
@export var apply_to_self: bool = false

func apply (context: EffectContext) -> void:
	var source: Entity = context.source
	var target: Entity = context.target
	var entity: Entity = target if ! apply_to_self else source

	for aura: BaseAura in auras:
		var instance: BaseAura = aura.duplicate()

		# TODO: not the biggest fan of this but I don't necessarily see another way to do this
		if "source" in instance: instance.source = source
		if "target" in instance: instance.target = target
		# TODO: check to see if there's any auras on the source or target that would affect this aura

		if (instance.icon == null): instance.icon = context.source_ability.icon
		entity.aura_component.add_aura(instance)
