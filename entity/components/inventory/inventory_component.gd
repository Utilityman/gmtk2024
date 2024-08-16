@icon("res://assets/icons/net/game-icons/backpack.16x16.svg")
class_name InventoryComponent extends Node

# DEVELOPING the inventory and musing about things
# only the SERVER theoretically needs to actually hold the item resource. Theoretically so long as the 
# server/client have the name, description and such 

@onready var bags: Array[BagComponent] = [
	$BagComponent0,
	$BagComponent1,
	$BagComponent2,
	$BagComponent3,
]
# TODO: item definitions likely will be resources, but they will all need to be instantiated into nodes here

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(bags)

func load (data: HeroData) -> void:
	if data.bag0: setup_bag(bags[0], data.bag0, data.bag0Items)
	if data.bag1: setup_bag(bags[1], data.bag1, data.bag0Items)
	if data.bag2: setup_bag(bags[2], data.bag2, data.bag0Items)
	if data.bag3: setup_bag(bags[3], data.bag3, data.bag0Items)

func setup_bag (bag: BagComponent, container: ItemContainer, items: Array[ItemStack]) -> void:
	bag.container = container
	# TODO: this is where we'd want to loot all of these items into the container 

# TODO: I'm not sure if I like the parameters here. I almost wish this was a bundled thing "Loot" 
func loot (loot: ItemStack) -> void:
	for bag in bags:
		if loot.quantity > 0:
			bag.loot(loot)