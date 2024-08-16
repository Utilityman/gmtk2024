@icon("res://assets/icons/net/game-icons/strong.16x16.green.svg")
class_name AuraBar extends HBoxContainer

@export var aura_filter: AuraFilter

# TODO: this can spawn in ActionButtons with a provider that watches an aura on the entity
var action_button: PackedScene = preload("res://interface/action/action_button.tscn")

var entity: Entity:
	set(new_entity):
		cleanup()
		entity = new_entity
		entity.aura_component.on_aura_added.connect(_on_aura_added)
		entity.aura_component.on_aura_removed.connect(_on_aura_removed)
		entity.aura_component.on_aura_refreshed.connect(_on_aura_refreshed)

		for aura: BaseAura in entity.aura_component.get_auras():
			_add_aura_to_scene(aura)

var _buffs: Dictionary = {}

func cleanup () -> void:
	if entity:
		entity.aura_component.on_aura_added.disconnect(_on_aura_added)
		entity.aura_component.on_aura_removed.disconnect(_on_aura_removed)
		entity.aura_component.on_aura_refreshed.disconnect(_on_aura_refreshed)
		for aura: BaseAura in _buffs.keys():
			var aura_button: ActionButton = _buffs[aura]
			aura_button.queue_free()
			_buffs.erase(aura)


func _add_aura_to_scene(aura: BaseAura) -> void:
	Logger.info("Adding Aura: " + aura.name + " to aura bar!")
	# if not aura_filter or not aura_filter.evaluate(aura): return 

	# TODO: for some reason the size isn't being obeyed here. Do we need to create a container which has size instead?
	var aura_button: ActionButton = action_button.instantiate()
	aura_button.hover_texture = null
	add_child(aura_button, true)
	aura_button.set_size(Vector2(40, 40))

	var aura_action_provider: AuraActionProvider = AuraActionProvider.new()
	aura_action_provider.aura = aura
	aura_action_provider.setup(entity)
	aura_button.action = aura_action_provider

	_buffs[aura] = aura_button

	if aura.duration > 0 and not aura.forever:
		# something this doesn't do well is translate the original max time to the action button
		# (for example clicking on/off a target with a debuff)
		aura_action_provider.on_timer_set.emit(aura.duration)

func _on_aura_added (aura: BaseAura) -> void:
	_add_aura_to_scene(aura)

func _on_aura_removed (aura: BaseAura) -> void:
	if _buffs.has(aura):
		var aura_button: ActionButton = _buffs[aura]
		aura_button.queue_free()
		_buffs.erase(aura)

func _on_aura_refreshed (aura: BaseAura) -> void:
	if _buffs.has(aura):
		var aura_button: ActionButton = _buffs[aura]
		aura_button.action.on_timer_update.emit(aura.duration)
	
