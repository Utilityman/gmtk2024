class_name EffectAura extends BaseAura

@export_range(0.0, 30.0, 0.1, "or_greater") var interval: float = 3.0
@export var use_on_start: bool = false

@export var effects: Array[_AbilityEffect]

var time_since_effect: float = 0.0

var target: Entity

func on_start () -> void: 
    super.on_start()
    if use_on_start: _apply_effects()

func on_end () -> void: 
    super.on_end()

func update (delta: float) -> void:
    super.update(delta)
    time_since_effect += delta
    while (time_since_effect / interval >= 1):
        _apply_effects()
        time_since_effect -= interval


func _apply_effects () -> void:
    for effect: _AbilityEffect in effects: 
        var context: EffectContext = EffectContext.new(source, target)
        context.source_aura = self
        effect.apply(context)
