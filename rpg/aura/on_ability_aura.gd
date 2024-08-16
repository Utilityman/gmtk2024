class_name OnAbilityAura extends _DamageChainAura

@export var effect: Array[_AbilityEffect] = []

func add_effects(effects: Array[_AbilityEffect]) -> void:
    effects.append_array(effect)