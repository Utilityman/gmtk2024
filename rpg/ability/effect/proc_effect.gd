class_name ProcEffect extends _AbilityEffect

@export_range(0.0, 100.0, 0.01) var percent_chance: float
@export var effects: Array[_AbilityEffect] = []

func should_activate () -> bool:
    var roll: float = (randi() % 100) / 100.0
    return roll <= percent_chance

func apply (context: EffectContext) -> void:    
    if should_activate():
        for effect in effects:
            effect.apply(context)