class_name AbilityContainer extends Control

@export var entity: Entity
@export var ability: Ability:
	set(new_ability):
		ability = new_ability
		name_label.text = ability.name
		var action_provider: AbilityActionProvider = AbilityActionProvider.new()
		action_provider.setup(entity)
		action_provider.ability = ability
		action.action = action_provider


@onready var action: ActionButton = $%ActionButton
@onready var name_label: Label = $%SpellnameLabel
