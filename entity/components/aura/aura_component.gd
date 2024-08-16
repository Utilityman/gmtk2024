# TODO: this is likely going to have to have a scene so that things can be replicated
@icon("res://assets/icons/net/game-icons/aura.16x16.svg")
class_name AuraComponent extends Node

signal on_aura_added
signal on_aura_removed
signal on_aura_refreshed

var _auras: Array[BaseAura]
var _casting_aura: CastingAura

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_auras = _auras.filter(func process(aura: BaseAura) -> bool: return process_aura(delta, aura))
	# TODO: where do I stop casting if the player is moving?

func process_aura(delta: float, aura: BaseAura) -> bool:
	aura.update(delta)

	if (not aura.forever and aura.is_complete()):
		print('ending the aura ', aura.name)
		_stop_aura(aura)
		return false
	return true

# TODO: auras that stack
func add_aura (aura: BaseAura) -> void:
	if aura is CastingAura:
		if _casting_aura != null:
			_auras.erase(_casting_aura)
		_casting_aura = aura

	var should_add_aura: bool = true
	if aura.is_unique == "by_entity":
		for existing_aura in _auras:
			if existing_aura.id and existing_aura.id == aura.id\
			and existing_aura.source == aura.source:
				should_add_aura = false
				existing_aura.refresh()
				on_aura_refreshed.emit(existing_aura)
	elif aura.is_unique == "by_aura":
		for _aura in _auras:
			if _aura.id == aura.id:
				print('found aura already')
		
	

	# TODO: do something with the "is_unique" property on the aura 
	# e.g character can't have multiple curse of elements auras
	# e.g an entity's fireball DOT will be refreshed when they use fireball again
	if should_add_aura:
		aura.on_start()
		_auras.append(aura)
		on_aura_added.emit(aura)

func remove_aura (aura: BaseAura) -> void:
	# TODO: theoretically if we ever pass a reference to the aura here, 
	# this won't find it since it wouldn't be "==" it
	var index: int = _auras.find(aura)
	if index != -1:
		var existing: BaseAura = _auras[index]
		# TODO: is this going to cause issues if "process" is occuring at the same time?
		_auras.erase(existing)
		_stop_aura(existing)

func _stop_aura (aura: BaseAura) -> void: 
	if (aura is CastingAura): _casting_aura = null
	aura.on_end()
	on_aura_removed.emit(aura)

func get_auras () -> Array[BaseAura]:
	return _auras

# TODO: for ease of use, more methods for like "get_buffs()" "get_debuffs()", etc.
