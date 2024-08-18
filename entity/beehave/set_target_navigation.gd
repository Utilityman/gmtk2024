class_name SetTargetNavigation extends ActionLeaf

func tick(actor: Node, _blackboard: Blackboard) -> int:
    var entity: NonPlayerEntity = actor as NonPlayerEntity
    entity.set_navigation_target(entity.target.global_position)

    return SUCCESS
