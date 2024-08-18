class_name GetEnemy extends ConditionLeaf

func tick(actor: Node, _blackboard: Blackboard) -> int:
    var entity: NonPlayerEntity = actor as NonPlayerEntity

    if entity.sensor.entities.size() == 0: return FAILURE

    var target: Entity = entity.sensor.entities[0]
    if entity.is_navigatable(target.global_position):
        entity.target = target
        return SUCCESS

    return FAILURE

