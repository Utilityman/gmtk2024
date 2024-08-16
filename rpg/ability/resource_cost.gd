class_name ResourceCost extends Resource

@export var resource_type: ResourceType.Type
@export_range(0, 100, 1, "or_greater") var quantity: int

