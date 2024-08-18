class_name StopNavigation extends ActionLeaf

func tick(actor: Node, _blackboard: Blackboard) -> int:
    var entity: NonPlayerEntity = actor as NonPlayerEntity
    entity.set_navigating(false)

    return SUCCESS
