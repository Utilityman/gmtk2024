@icon("res://assets/icons/net/game-icons/network-bars.16x16.svg")
class_name StatsComponent extends Node
# TODO: %modifiers? (should probably be in the stat blocks??)
# TODO: these stats probably want to be more complex objects, health could be using the stat_pool object
# TODO: intersting idea from https://zennyth.github.io/EnhancedStat where something like "controllable" as a boolean "stat"
# 		- this would be good to control stuns and such
# TODO: from GameCreator.io they have separate "Attributes" from "Stats" https://docs.gamecreator.io/stats/classes/traits/
# 		- Stats represent a specific singular value for a trait (Strength, Dex, Int come to mind)
#		- Attributes represents a range clamped between a min/max range (Health, Mana, Rage)

# Statistics 
@onready var hitpoints: Statistic = $Hitpoints
@onready var vitality: Statistic = $Vitality
@onready var strength: Statistic = $Strength
@onready var dexterity: Statistic = $Dexterity
@onready var intelligence: Statistic = $Intelligence
@onready var constitution: Statistic = $Constitution
@onready var armor: Statistic = $Armor
@onready var ward: Statistic = $Ward

# Attributes (this would also be class resources, but are present only when needed)
@onready var health: Attribute = $Health

var resources: Dictionary = {}

# TODO: is there a way to know if a source block changes? Or otherwise, is there even a chance that a stat block would change?
# TODO: how to know how to add/remove specific stat blocks? 
var _source_blocks: Array[StatBlock]

func calculate_stats() -> void:
	# get bases
	hitpoints.value = get_stat_base('hitpoints')
	vitality.value = get_stat_base('vitality')
	strength.value = get_stat_base('strength')
	dexterity.value = get_stat_base('dexterity')
	intelligence.value = get_stat_base('intelligence')
	constitution.value = get_stat_base('constitution')
	armor.value = get_stat_base('armor')
	ward.value = get_stat_base('ward')

	# TODO: when/how to calculate attributes?

	# TODO: converted stats
	# TODO: % bonus

	# then finally attributes?? what if any attribute were to have modifiers?
	# TODO: is there a better way to do this than this?
	health.value = (vitality.value * 6) + hitpoints.value + (strength.value * 2)

func add_stat_block(stat_block: StatBlock) -> void:
	_source_blocks.append(stat_block)
	calculate_stats()

# How does Rage know to deplete and mana know to regenerate? Relatedly, how does health know to regenerate?
# TODO: I really don't like this. It should add this through a stat_block so that it could later be referenced/removed
func add_resource (type: ResourceType.Type, quantity: int) -> void:
	if not resources.has(type):
		resources[type] = StatPool.new()
	resources[type].max_value += quantity

func get_stat_base(stat_name: String) -> int: 
	if _source_blocks.is_empty(): return 0
	return _source_blocks.map(func (block: StatBlock) -> int: return block[stat_name]).reduce(
			func (iterated: int, acc: int) -> int: return iterated + acc
		)
