@icon("res://assets/icons/godot/Camera3D.svg")
class_name ObservingCamera extends Node3D

signal on_entity_raycast

@export var entity: Entity

# TODO: these are good and sensible defaults, maybe want to have some sort of way to override them?
@export_category("Camera Configuration")
@export var camera_spring_length: float = 5.0
@export var mouse_sensitivity: float = 0.0015 # TODO: more of a global variable?
@export var camera_zoom_step: float = 1.0
@export var camera_zoom_smoothness: float = 4.0
@export var camera_max_zoom: float = 15.0
@export var camera_min_zoom: float = 2.0
@export var look_up_max_angle: float = 90.0
@export var look_down_max_angle: float = -80.0

@onready var _camera_pivot_y: Node3D = $CameraPivotY
@onready var _camera_pivot_x: Node3D = $CameraPivotY/CameraPivotX
@onready var _spring_arm: SpringArm3D = $CameraPivotY/CameraPivotX/SpringArm
@onready var _camera: Camera3D = $CameraPivotY/CameraPivotX/SpringArm/Camera
@onready var _raycast_selector: RayCast3D = $CameraPivotY/CameraPivotX/SpringArm/Camera/RayCast3D

const HALF_PI: float = PI / 2

# TODO: this whole cursor position thing is pretty awk
var last_cursor_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	last_cursor_position = get_viewport().get_mouse_position()

func set_as_current () -> void:
	_camera.current = true

func configure (node: Node3D) -> void:
		# Avoid the spring_arm colliding with the Character
	_spring_arm.add_excluded_object(node.get_rid())
	_spring_arm.spring_length = camera_spring_length

func _input(event: InputEvent) -> void:
	if _camera.current == true:
		if event as InputEventMouseMotion:
			_camera_pivot_y.rotate_y(-event.relative.x * mouse_sensitivity)

			_camera_pivot_x.rotate_x(-event.relative.y * mouse_sensitivity)
			_camera_pivot_x.rotation_degrees.x = clampf(_camera_pivot_x.rotation_degrees.x, look_down_max_angle, look_up_max_angle)
		if Input.is_action_pressed(&"CAMERA_ZOOM_UP"):
			camera_spring_length = clampf(camera_spring_length + camera_zoom_step, camera_min_zoom, camera_max_zoom)
		if Input.is_action_pressed(&"CAMERA_ZOOM_DOWN"):
			camera_spring_length = clampf(camera_spring_length - camera_zoom_step, camera_min_zoom, camera_max_zoom)

	if Input.is_action_just_pressed(&"WORLD_SELECT") and (event as InputEventMouseButton):
		var mouse_position: Vector2 = get_viewport().get_mouse_position()
		# TODO: raycast length magic number?
		_raycast_selector.target_position = _camera.project_local_ray_normal(mouse_position) * 100.0
		_raycast_selector.force_raycast_update()
		if _raycast_selector.is_colliding():
			var collider: Object = _raycast_selector.get_collider()
			if collider is Entity:
				on_entity_raycast.emit(collider)
			else:
				Logger.info(str(collider))

func _physics_process(delta: float) -> void:
	if entity:
		# annoying stupid code to get the camera controls going
		# entity.rotation.y = lerp(entity.rotation.y, _camera_pivot_y.rotation.y, 12.0 * delta)
		if entity.is_alive: entity.rotation.y = lerp_angle(entity.rotation.y, _camera_pivot_y.rotation.y, 12.0 * delta)
		_camera_pivot_y.global_position = global_position

func _process(delta: float) -> void:
	if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		last_cursor_position = get_viewport().get_mouse_position()
	if camera_spring_length != _spring_arm.spring_length:
		_spring_arm.spring_length = lerpf(
			_spring_arm.spring_length, 
			camera_spring_length, 
			delta * camera_zoom_smoothness
		)


func look_forward(delta: float, forward: Vector3) -> void:
	var angle: float = atan2(forward.z, -forward.x) - HALF_PI
	var destination_angle: float = lerp_angle(_camera_pivot_y.rotation.y, angle, delta * camera_zoom_smoothness)
	_camera_pivot_y.rotation.y  = destination_angle
