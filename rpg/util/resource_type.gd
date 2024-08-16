class_name ResourceType extends Resource

enum Type { NONE, RAGE, MANA, ENERGY }

static func as_string (type: Type) -> String:
    if type == 1: return &"RAGE"
    if type == 2: return &"MANA"
    if type == 3: return &"ENERGY"
    return &"UNKNOWN"
