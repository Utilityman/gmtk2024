class_name SetMode extends Leaf

func tick(actor: Node, _blackboard: Blackboard) -> int:
    var entity: NonPlayerEntity = actor as NonPlayerEntity

    if entity.mode: return SUCCESS

    var puncher: bool = randi() % 2 == 0
    if puncher: entity.mode = "punch"
    else: entity.mode = "shoot"
    # entity.mode = "punch"

    return SUCCESS