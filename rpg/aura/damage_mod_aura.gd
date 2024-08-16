class_name DamageModAura extends _DamageChainAura

@export var flat_modification: int = 0
@export_range(-1.0, 1.0, 0.01, "or_greater", "or_less") var percent_modification: float = 0.0
