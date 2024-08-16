# the thing that's really too bad her, that I need to figure out is that I need a way to 
# have a sort of Interface that has "is_jumping" / "get_direction" that could be any sort of node
class_name NetworkedPlayerInputProvider extends MultiplayerSynchronizer

@export var jumping: bool = false:
    set(value):
        jumping = value
@export var direction: Vector3 = Vector3()
@export var rotation: float = 0.0

func _process(_delta: float) -> void:
    var input_dir: Vector2 = Input.get_vector(
		&"MOVE_LEFT", &"MOVE_RIGHT", &"MOVE_FORWARD", &"MOVE_BACK"
	)
    direction = Vector3(input_dir.x, 0.0, input_dir.y)

    var rotate_dir: float = 0.0
    if Input.is_action_pressed(&"ROTATE_LEFT"):
        rotate_dir += 1.0
    if Input.is_action_pressed(&"ROTATE_RIGHT"):
        rotate_dir -= 1.0
    rotation = rotate_dir

    if Input.is_action_just_pressed(&"JUMP"): jump.rpc_id(1)

@rpc("any_peer", "call_local", "reliable")
func jump() -> void:
    jumping = true

func _on_multiplayer_authority_changed (id: int) -> void:
    set_multiplayer_authority(id)
    set_process(get_multiplayer_authority() == multiplayer.get_unique_id())
