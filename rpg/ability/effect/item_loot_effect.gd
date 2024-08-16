class_name ItemLootEffect extends _AbilityEffect

@export var item: Item
@export var quantity: int = 1

func apply (context: EffectContext) -> void:
	var source: Entity = context.source

	var loot: ItemStack = ItemStack.new()
	loot.item = item
	loot.quantity = quantity

	# TODO: for some reason the ItemLootEffect still things this is one despite being set to 3 in the "Find Chicken" skill
	print("Loot: " + item.name)
	print("Quantity: " + str(quantity))

	source.inventory.loot(loot)
