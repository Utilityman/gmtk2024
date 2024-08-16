class_name AuraActionProvider extends _ActionProvider

# TODO: how can this signal to the action that there's a timer active

@export var aura: BaseAura

func get_icon () -> Texture2D:
    return aura.icon

func has_tooltip () -> bool: return true

func get_tooltip_title () -> String:
    return aura.name

func get_tooltip_description () -> String:
    return aura.description