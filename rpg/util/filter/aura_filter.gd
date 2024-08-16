class_name AuraFilter extends Resource

@export var aura_id: String
@export var negate_id: bool = false

# TODO: aura types and subtypes as an enum somewhere else
@export_enum("none", "spell_cast", "feature", "buff", "debuff") var type: String
@export_enum("magic", "curse", "disease", "bleed", "enrage") var sub_type: String

func evaluate(aura: BaseAura) -> bool: 

    if aura_id and not negate_id and aura_id != aura.id: return false
    if aura_id and negate_id and aura_id == aura.id: return false

    if type and type != aura.type: return false
    if sub_type and sub_type != aura.sub_type: return false

    return true