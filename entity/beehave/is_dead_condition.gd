class_name IsDeadCondition extends ConditionLeaf

func tick(actor: Node, _blackboard: Blackboard) -> int:
    var entity: NonPlayerEntity = actor as NonPlayerEntity

    if entity.is_alive: return FAILURE
    return SUCCESS
