class_name _AbilityDatabase extends Node


# TODO: for the time being while this is storing stuff locally, I kinda want to scan the entire "implementation" directory and add ANY items from there
# 		into here

@export var stored_abilities: Array[Ability]:
	set(new_store):
		stored_abilities = new_store
		for ability: Ability in stored_abilities:
			if not _database.has(ability.id):
				_database[ability.id] = ability

# TODO: this is great and cool for the time being but currently has all of the abilities in-memory all the time
# 		instead we could store these into a real proper _database for on-demand access. Whatever _database interface
# 		will likely want to be able to cache abilities in-memory so full DB I/O won't necessarily be necessary every query.
var _database: Dictionary = {}

func get_by_id (id: String) -> Ability:
	if _database.has(id):
		return _database[id]
	else: 
		Logger.warn("Could not find spell: " + id + " in _database")
		return null