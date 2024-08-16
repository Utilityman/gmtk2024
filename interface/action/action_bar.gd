class_name  ActionBar extends Control

# TODO: eventually we will want to have some sort of saved configuration outside of the entity to help configure these bars
# 		this configuration will likely have to be provided for a new character and hopefully can be persisted/saved and reused as a player modifies it
# TODO: actually since the client doesn't actually have access to the entity's spellbook, does this need to happen sooner?

@onready var actions: Array[ActionButton] = [
	$%ActionButton0,
	$%ActionButton1,
	$%ActionButton2,
	$%ActionButton3,
	$%ActionButton4,
	$%ActionButton5,
	$%ActionButton6,
	$%ActionButton7,
	$%ActionButton8,
	$%ActionButton9,
]

@export var action_bar_input_base: String
@export var entity: Entity:
	set(new_entity):
		entity = new_entity
		# TODO: just iterate over the entity's spellbook and creeate action providers for each thing
		# TODO: this isn't great because on remote connections we don't have access to entity.data
		# if entity.data:
		# 	for i: int in entity.data.spellbook.abilities.size():
		# 		var ability: Ability = entity.data.spellbook.abilities[i]
		# 		# TODO: this is great, but a lot isn't working - specifically in the ActionButton
		# 		# 	- global cooldown
		# 		# 	- cooldown
		# 		# 	- does it have the gray overlay?
		# 		Logger.info("Adding: " + ability.name)
				
		# 		var abilityAction: AbilityActionProvider = AbilityActionProvider.new()
		# 		abilityAction.ability = ability
		# 		abilityAction.setup(entity)
		# 		actions[i].action = abilityAction

func _ready() -> void:
	# this seems quite fine for now
	if action_bar_input_base:
		for index in range(actions.size()):
			actions[index].shortcut_key = action_bar_input_base + "_" + str(index)

	# var uiConfig: PlayerUIConfig = Settings.current_character().uiConfig

