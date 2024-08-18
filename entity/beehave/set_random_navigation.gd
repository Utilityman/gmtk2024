class_name SetRandomNavigation extends ActionLeaf

func tick(actor: Node, _blackboard: Blackboard) -> int:
    var entity: NonPlayerEntity = actor as NonPlayerEntity
    entity.set_random_navigation_target()

    return SUCCESS
