class_name ReplicatedSceneData extends Resource

const replicated_scene = preload("res://game/multiplayer/replicated_scene_3d.tscn")

# this POTENTIALLY could be bad if the packed scene is something more than just graphics, something that has a script attached to it 
# or otherwise can otherwise also execute code alongside with this. Need to take care that the model is going to be able to be ran on the client
@export var model: PackedScene
@export var model_direction: Vector3 = Vector3(0, 0, -1)

func as_replicated_scene () -> ReplicatedScene3D:
    var instance: ReplicatedScene3D = replicated_scene.instantiate()
    instance.model_path = model.resource_path
    instance.model_direction = model_direction

    # for the instantiator (the server) setup the replicated scene without waiting for replication to happen
    instance.setup_from_packed(model)
    return instance
