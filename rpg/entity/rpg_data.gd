# TODO: something awkward here is that theoretically everyone needs their own instance of the data
#       which unfortunately means that entities would be able to share a definition but still need 
#       some other place to insert custom data (thinking of unique entity names)
#       This would mostly be a problem thinking about generating a village of NPCs all of which 
#       might basically use "base_definition" but of course have unique names and such.
#       This would be less of a problem for something like non-unique Goblins/Guards
class_name RpgData extends Resource

# TODO: name attributes and such
# - this is going to be necessary here as we want this to be the core data that is sent to the server when connecting and managed by the MultiplayerManager
#   and the name is going to help easier debug issues

# TODO: This might be cool, but we might need to node-ify this to be able to use the multiplayer sychronizer on any of the properties
# TODO: ACTUALLY (BIG MAYBE) since the Cooldowns, Auras, and Stats are nodes; we'd be able to sychronize those instead and then just be fine(?)

@export_category("Descriptive Attributes")
@export var name: String

@export_category("Entity Attributes")
@export var level: int = 1
@export var base_stats: StatBlock
@export var spellbook: Spellbook

# TODO: where/how is model information stored in here?

