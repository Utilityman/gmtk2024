class_name InterfaceActionProvider extends _ActionProvider

@export var icon: Texture2D
@export var title: String
@export var window_id: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func get_icon () -> Texture2D: 
	return icon

func activate () -> void:
	pass

func has_tooltip () -> bool: return title != ""
func get_tooltip_title () -> String: return title