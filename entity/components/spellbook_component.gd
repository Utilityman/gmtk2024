@icon("res://assets/icons/net/game-icons/book-cover.16x16.svg")
class_name SpellbookComponent extends Node

# TODO: this will somehow need to interact with the equipment to know which weapon abilities are available derived from the weapon

signal spells_updated

@export var spells: Array[Ability]:
	set(new_spells):
		spells = new_spells
		spells_updated.emit(spells)

@export var spell_ids: Array:
	set(new_ids):
		spell_ids = new_ids
		var spell_lookups: Array[Ability] = []
		for spell_id: String in spell_ids as Array[String]:
			var lookup: Ability = AbilityDatabase.get_by_id(spell_id)
			if lookup != null:
				spell_lookups.append(lookup)
		spells = spell_lookups

func load_data (data: Spellbook) -> void:
	spell_ids = data.abilities.map(func (ability: Ability) -> String: return ability.id)

func has_learned (ability: Ability) -> bool:
	return spells.filter(func (learned_ability: Ability) -> bool: return learned_ability.id == ability.id).size() > 0

func log () -> void:
	Logger.info("Spellbook (" + str(spells.size()) + " spells)")
	for ability: Ability in spells:
		print(ability.name + " [" + ability.id + "]")