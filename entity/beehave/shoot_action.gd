class_name ShootAction extends ActionLeaf

func tick(actor: Node, _blackboard: Blackboard) -> int:
    var entity: NonPlayerEntity = actor as NonPlayerEntity
    entity.use_ability(entity.shoot_ability, entity)

    return SUCCESS