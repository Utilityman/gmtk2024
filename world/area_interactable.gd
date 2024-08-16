extends Area3D

@export var effect: _AbilityEffect

func _ready() -> void:
	body_entered.connect(on_character_body_entered)


func on_character_body_entered(body: Node3D) -> void:
	if body is Entity and effect:
		# this is weird and awkward - what if this wanted to reduce all cooldowns of the person
		# effect.apply(null, body)
		print('Im an interactable area with an effect to apply please')

