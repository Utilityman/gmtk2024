class_name WaitForDynamicNavigation extends ConditionLeaf

func tick (actor: Node, _blackboard: Blackboard) -> int:
    var entity: NonPlayerEntity = actor as NonPlayerEntity

    entity.set_navigation_target(entity.target.global_position, 0.3)
    if entity.is_at_destination() or not entity.is_destination_reachable():
        return SUCCESS
    return RUNNING