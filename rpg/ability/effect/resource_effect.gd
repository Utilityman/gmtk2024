class_name ResourceEffect extends _AbilityEffect

@export var resource_type: ResourceType.Type
@export var quantity: float
@export var apply_to_self: bool = true

func apply (context: EffectContext) -> void:
	var source: Entity = context.source
	var target: Entity = context.target
	var entity: Entity = target if ! apply_to_self else source

	var resource_pool: StatPool = entity.stats_component.resources.get(resource_type)
	if resource_pool: resource_pool.current_value += quantity
