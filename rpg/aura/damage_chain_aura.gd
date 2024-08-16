class_name _DamageChainAura extends BaseAura

@export var filters: Array[ContextFilter] = []

func should_activate (context: EffectContext) -> bool:
    for filter: ContextFilter in filters:
        if not filter.evaluate(context): return false

    return true