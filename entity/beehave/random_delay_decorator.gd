class_name RandomDelayDecorator extends DelayDecorator

# TODO: weird name? This is basically how much plus or minus it could be
@export var delta: float = 0.5

func before_run(_actor: Node, _blackboard: Blackboard) -> void:
    wait_time = clamp(randf_range(wait_time - delta, wait_time + delta), 0, wait_time + delta)
    