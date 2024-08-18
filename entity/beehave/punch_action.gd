class_name PunchAction extends ActionLeaf

func tick(actor: Node, _blackboard: Blackboard) -> int:
    var entity: NonPlayerEntity = actor as NonPlayerEntity
    entity.use_ability(entity.melee, entity)
    return SUCCESS