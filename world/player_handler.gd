class_name PlayerHandler extends Node

# TODO: where do I add the component for the UI
# TODO: how do I move the camera to be on the player
# TODO: does this handle it or somehting else?

# TODO: this could probably be a preload instead of an export
@export var player_packed_scene: PackedScene

@export var spawn_locations: Array[Node3D] = []

func _ready() -> void:
    Logger.info("player handler ready!")
    # for user: MultiplayerUser in MultiplayerManager.users.get_children():
        # _on_new_player(id, MultiplayerManager.users[id])
    # MultiplayerManager.on_new_player.connect(_on_new_player)
    pass

func _on_new_player(id: int, player_data: HeroData) -> void:
    add_player(_pick_spawn_location(), id, player_data)

# TODO: the thing about some of this is that the MultiplayerManager does not keep track of 
#       where the player is. Which isn't necessarily great. 
func add_player (position: Vector3, id: int, player_data: HeroData) -> void:
    var player_scene: NetworkedPlayer = player_packed_scene.instantiate()
    player_scene.name = str(id) # TODO: can we put the multiplayer id somewhere better?
    var hero_data: HeroData = load("res://implementation/hero/cleric_hero_definition.tres")
    player_scene.data = hero_data

    add_child(player_scene)

    # some sort of set position function to set the initial sync position to not zero
    player_scene.global_position = position

func _pick_spawn_location () -> Vector3: 
    if spawn_locations.size() == 0: return Vector3(0, 0, 0)
    return spawn_locations.pick_random().global_position
