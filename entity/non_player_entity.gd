class_name NonPlayerEntity extends Entity

@export var enable_navigation: bool = false

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D

var agent_velocity: Vector3 = Vector3.ZERO


func _ready() -> void:
    super._ready()
    nav_agent.velocity_computed.connect(_set_computed_velocity)

func _physics_process(delta: float) -> void:
    super._physics_process(delta)

    var direction: Vector3 = nav_agent.get_next_path_position() - self.global_position

    # if the direction is super small, don't even bother
    if direction.distance_squared_to(Vector3.ZERO) < 0.1: direction = Vector3.ZERO
    nav_agent.velocity = direction

    var y_rot: float = atan2(-velocity.x, -velocity.z)
    rotation.y = lerp_angle(rotation.y, y_rot, 10.0 * delta)

func get_direction () -> Vector3: 
    if not is_alive or not enable_navigation: return Vector3.ZERO
    return  nav_agent.get_next_path_position() - self.global_position

# this isn't working again :(
func _set_computed_velocity (computed_velocity: Vector3) -> void:
    agent_velocity = computed_velocity

func set_navigating (is_navigating: bool) -> void:
    enable_navigation = is_navigating

func is_at_destination () -> bool:
    return nav_agent.is_target_reached()

func set_random_navigation_target () -> void:
    var navigation_target: Vector3 = random_on_unit_circle_v3()
    print("Guessed Navigation Target: " + str(navigation_target))

    var map: RID = nav_agent.get_navigation_map()
    nav_agent.target_position = NavigationServer3D.map_get_closest_point(map, navigation_target)
    print("Navigation Target Position: " + str(nav_agent.target_position))

func random_on_unit_circle_v3() -> Vector3:
    var _v2: Vector2 = random_on_unit_circle()
    return Vector3(_v2.x, 0, _v2.y)

func random_on_unit_circle() -> Vector2:
    var _rV3 : Vector3 = random_vector3().normalized()
    var _rV2 : Vector2 = Vector2(_rV3.x, _rV3.y)
    var _angle : Vector2 = Vector2.ZERO.direction_to(_rV2)
    return _angle

func random_vector3() -> Vector3:
    var x0 : float = -1.0 + randf() * 2.0
    var x1 : float = -1.0 + randf() * 2.0
    var x2 : float = -1.0 + randf() * 2.0
    var x3 : float = -1.0 + randf() * 2.0
    while x0 * x0 + x1 * x1 + x2 * x2 + x3 * x3 >= 1:
        x0 = -1.0 + randf() * 2.0
        x1 = -1.0 + randf() * 2.0
        x2 = -1.0 + randf() * 2.0
        x3 = -1.0 + randf() * 2.0
    var a : float = x0*x0*x1*x1+x2*x2+x3*x3
    var x : float = 2*(x1 * x3+x0*x2)/a
    var y : float = 2*(x2*x3-x0*x1)/a
    var z : float = (x0*x0 + x3*x3 - x1*x1 - x2*x2)/a
    return Vector3(x,y,z)


