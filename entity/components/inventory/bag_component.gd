class_name BagComponent extends Node

@export var container: ItemContainer:
    set(new_container):
        container = new_container
        bag_slots = [] # TODO: this would just eliminate all the items in the previous bag
        for i: int in range(container.size):
            bag_slots.push_front(null)

# TODO: this is the data, very cool. But this also needs to exist in Node format for replication
var bag_slots: Array[ItemStack] = []

func loot (loot: ItemStack) -> void:
    # TODO: I probably want to have a bag aware of stacking items and attempt to stack them if possible
    for i: int in bag_slots.size():
        if loot.quantity == 0: break
        if not bag_slots[i]:
            var new_stack: ItemStack = ItemStack.new()
            new_stack.item = loot.item

            # determine stack quantity by taking either the loot quantity
            var stack_quantity: int = loot.quantity
            if stack_quantity > loot.item.max_stack_count:
                # or the max_stack_count if the loot's quantity is greater than that
                stack_quantity = loot.item.max_stack_count
            
            # subtract the quantity from the loot, and the item stack to the bag
            loot.quantity -= stack_quantity
            new_stack.quantity = stack_quantity

            bag_slots[i] = new_stack