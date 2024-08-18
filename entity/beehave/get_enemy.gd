class_name GetEnemy extends ConditionLeaf

@export var iterations_to_keep_target: int = 5

var target_iterations: int = 0

func tick(actor: Node, _blackboard: Blackboard) -> int:
    var entity: NonPlayerEntity = actor as NonPlayerEntity

    if entity.sensor.entities.size() == 0: 
        target_iterations = 0
        return FAILURE

    var current_target: Entity = entity.target
    if current_target and current_target.is_alive and entity.is_navigatable(current_target.global_position) and target_iterations < iterations_to_keep_target:
        target_iterations += 1
        return SUCCESS

    var local_entities: Array[Entity] = entity.sensor.entities.duplicate()
    var potential_targets: Array = [
        local_entities.pop_front(), 
        local_entities.pop_front(), 
        local_entities.pop_front(),
        local_entities.pop_back(),
        local_entities.pop_back()
    ].filter(func (item: Entity) -> bool: return item != null)

    while potential_targets.size() > 0:
        var potential_target: Entity = potential_targets.pick_random() as Entity
        potential_targets.erase(potential_target)
        if potential_target is LocalPlayerEntity: continue

        if entity.is_navigatable(potential_target.global_position):
            target_iterations = 0
            entity.target = potential_target
            return SUCCESS

    return FAILURE

