class_name NetworkedPlayer extends Entity

# TODO: the HostSynchronizer might have to be on each base Entity object

signal multiplayer_authority_changed

@export var client_multiplayer_id: int = 1:
	set(value):
		if not value or value < 1: return
		client_multiplayer_id = value
		multiplayer_authority_changed.emit(client_multiplayer_id)

@onready var name_label: Label3D = $NameLabel
@onready var host_sychronizer: MultiplayerSynchronizer = $HostSynchronizer
@onready var client_input: NetworkedPlayerInputProvider = $PlayerInputProvider

func _ready() -> void:
	super._ready()
	_on_entity_name_change(info.entity_name)
	info.on_entity_name_change.connect(_on_entity_name_change)
	multiplayer_authority_changed.connect(client_input._on_multiplayer_authority_changed)

func _on_entity_name_change (value: String) -> void:
	name_label.text = value

func _input(_input_event: InputEvent) -> void:
	# TODO: on right click and drag, want to rotate the player (and camera)
	return

func should_jump () -> bool:
	if client_input.jumping:
		client_input.jumping = false
		return true
	return false

func get_direction () -> Vector3:
	return (global_transform.basis * client_input.direction).normalized()

func get_rotate_direction () -> float:
	return client_input.rotation

func _physics_process(delta: float) -> void:
	if not multiplayer.is_server():
		pass # TODO: do some sychronizing things
	super._physics_process(delta)