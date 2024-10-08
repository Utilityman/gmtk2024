class_name NonPlayerEntity extends Entity

@export var enable_navigation: bool = false
@export var mode: String:
    set(new_mode):
        mode = new_mode
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var nav_tester: NavigationAgent3D = $NavigationTester3D
@onready var sensor: Area3D = $EntitySensor

var agent_velocity: Vector3 = Vector3.ZERO

func _ready() -> void:
    super._ready()
    nav_agent.velocity_computed.connect(_set_computed_velocity)

func _physics_process(delta: float) -> void:
    super._physics_process(delta)

    var direction: Vector3 = global_position.direction_to(nav_agent.get_next_path_position()) if is_alive else Vector3.ZERO
    nav_agent.velocity = direction

    if velocity:
        var y_rot: float = atan2(-velocity.x, -velocity.z)
        rotation.y = lerp_angle(rotation.y, y_rot, 10.0 * delta)

func get_direction () -> Vector3: 
    if not is_alive or not enable_navigation: return Vector3.ZERO
    return global_position.direction_to(nav_agent.get_next_path_position())

func face_target () -> void:
    if is_alive:
        var target_pos: Vector3 = target.global_position
        target_pos.y = global_position.y
        look_at(target_pos)

# this isn't working again :( and I really want it to
func _set_computed_velocity (computed_velocity: Vector3) -> void:
    agent_velocity = computed_velocity

func set_navigating (is_navigating: bool) -> void:
    enable_navigation = is_navigating

func is_at_destination () -> bool:
    return nav_agent.is_target_reached()

func is_destination_reachable () -> bool:
    if nav_agent.is_target_reachable(): return true
    return false

func is_navigatable (vector: Vector3) -> bool:
    nav_tester.target_position = vector
    # print("Is Reachable?: " + str(nav_tester.is_target_reachable()))
    return nav_tester.is_target_reachable()

func set_navigation_target (target_loc: Vector3, additional_radius: float) -> void:
    var navigation_target: Vector3 = random_on_unit_circle_v3() * additional_radius + target_loc

    var map: RID = nav_agent.get_navigation_map()
    nav_agent.target_position = NavigationServer3D.map_get_closest_point(map, navigation_target)

func set_random_navigation_target () -> void:
    var navigation_target: Vector3 = random_on_unit_circle_v3() * 5 + global_position

    var map: RID = nav_agent.get_navigation_map()
    nav_agent.target_position = NavigationServer3D.map_get_closest_point(map, navigation_target)

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


