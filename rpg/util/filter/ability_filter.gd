class_name AbilityFilter extends ContextFilter

# TODO: filter by ability tags, or its school, etc.

# TODO: this is doing some ability filtering, can I put additional filters into this? 
# that way we could have multiple AbilityFilters that get OR'd together if this can be relied on to AND a lot of things togehter
@export var ability_ids: Array[String] = []
@export var negate_ids: bool = false

@export_category("Cost Filter")
@export var cost_type: ResourceType.Type
@export var negate_cost_type: bool = false

func evaluate(context: EffectContext) -> bool:
    if not context.source_ability: return false
    var ability: Ability = context.source_ability

    if not ability_ids.is_empty():
        if not negate_ids and not ability_ids.has(ability.id): return false
        if negate_ids and ability_ids.has(ability.id): return false

    if cost_type:
        var found_cost_type: bool = false
        for cost in ability.resource_costs:
            if cost.resource_type == cost_type:
                found_cost_type = true
        if not negate_cost_type and found_cost_type: return false
        if negate_cost_type and not found_cost_type: return false

    return true