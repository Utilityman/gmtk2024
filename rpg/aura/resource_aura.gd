class_name ResourceAura extends BaseAura

@export var resource_type: ResourceType.Type
@export_range(0, 100, 1, "or_greater", "or_less") var quantity: int
@export var add_quantity: bool = false

func on_start () -> void:
	source.stats_component.add_resource(resource_type, quantity)
	if add_quantity: source.stats_component.resources[resource_type].current_value += quantity

