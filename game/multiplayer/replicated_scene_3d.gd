class_name ReplicatedScene3D extends Node3D

@export var model_path: String
@export var model_direction: Vector3 = Vector3(0, 0, -1)

@onready var synchronizer: MultiplayerSynchronizer = $MultiplayerSynchronizer

func _ready() -> void:
    synchronizer.delta_synchronized.connect(on_synchronized)

func on_synchronized () -> void:
    setup_from_packed(load(model_path))

func setup_from_packed (packed: PackedScene) -> void:
    var scene: Node = packed.instantiate()
    add_child(scene)
    scene.rotation.x = atan2(model_direction.z, model_direction.y) + (PI / 2)
    scene.rotation.z = atan2(-model_direction.y, model_direction.z) + (PI / 2)
