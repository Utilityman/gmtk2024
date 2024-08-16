class_name SpellbookWindow extends Control

@onready var actions: Array[AbilityContainer] = [
	$%AbilityContainer0,
	$%AbilityContainer1,
	$%AbilityContainer2,
	$%AbilityContainer3,
	$%AbilityContainer4,
	$%AbilityContainer5,
	$%AbilityContainer6,
	$%AbilityContainer7,
	$%AbilityContainer8,
	$%AbilityContainer9,
]

@export var entity: Entity:
	set(new_entity):
		entity = new_entity
		setup_layout(entity.spellbook.spells)
		entity.spellbook.spells_updated.connect(setup_layout)
		
func setup_layout (spells: Array[Ability]) -> void:
	# TODO: for the time being we're just going to put the first 10 spells into the spellbook
	for i in range(10):
		actions[i].entity = entity
		if i < spells.size() and spells[i] != null:
			actions[i].ability = spells[i]
