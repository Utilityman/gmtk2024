class_name WaitForDestination extends ConditionLeaf

func tick (actor: Node, _blackboard: Blackboard) -> int:
    var entity: NonPlayerEntity = actor as NonPlayerEntity
    if entity.is_at_destination():
        print("Is at Destination!")
        return SUCCESS
    return RUNNING