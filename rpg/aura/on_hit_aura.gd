class_name OnHitAura extends _DamageChainAura

# TODO: need some way to filter the on hit to see if it should on_activate

# This is where the fact that all of these are ability effects REALLY stinks - 
@export var effects: Array[_AbilityEffect] = []

func on_activate (context: EffectContext) -> void:
	for effect: _AbilityEffect in effects:
		var aura_ctx: EffectContext = EffectContext.new(context.source, context.target)
		context.source_aura = self
		effect.apply(aura_ctx)
