class_name ModeConditional extends ConditionLeaf

@export var mode: String

func tick(actor: Node, _blackboard: Blackboard) -> int:
    var entity: NonPlayerEntity = actor as NonPlayerEntity

    if entity.mode != mode: return FAILURE
    return SUCCESS
