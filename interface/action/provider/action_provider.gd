class_name _ActionProvider extends Resource

# TODO: how can this provide signals to help instruct the timer
# TODO: we almost need to pass the entity to this to initialize some wiring

signal on_timer_set
signal on_timer_update

func setup (_entity: Entity) -> void: pass

func get_icon () -> Texture2D: return null

func activate () -> void: pass

func has_tooltip () -> bool: return false

func get_tooltip_title () -> String: return ''

func get_tooltip_description () -> String: return ''
