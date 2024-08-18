class_name NonPlayerEntity extends Entity

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D

var agent_velocity: Vector3

func _ready() -> void:
    super._ready()
    nav_agent.velocity_computed.connect(_set_computed_velocity)

func _physics_process(delta: float) -> void:
    super._physics_process(delta)
    nav_agent.target_position = Vector3.ZERO

    var direction: Vector3 = nav_agent.get_next_path_position() - self.global_position

    # if the direction is super small, don't even bother
    if direction.distance_squared_to(Vector3.ZERO) < 0.1: direction = Vector3.ZERO
    nav_agent.velocity = direction

func get_direction () -> Vector3: 
    if not is_alive: return Vector3.ZERO
    return agent_velocity

func _set_computed_velocity (velocity: Vector3) -> void:
    agent_velocity = velocity
