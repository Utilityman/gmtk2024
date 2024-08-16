class_name Spellbook extends Resource

# TODO: consider what/why this exists rather than just giving the rpg_data an array of abilities
# - do I want to sort the abilities into general / class-abilities / extras ??
# - what else does the spellbook do?

@export var abilities: Array[Ability]
