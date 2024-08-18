class_name WaitForDestination extends ConditionLeaf

func tick (actor: Node, _blackboard: Blackboard) -> int:
    var entity: NonPlayerEntity = actor as NonPlayerEntity
    if entity.is_at_destination() or not entity.is_destination_reachable():
        return SUCCESS
    return RUNNING