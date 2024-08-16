extends Node3D

# TODO: I think a big thing will be to get MANY of the player handling / network components
# 		to be externalized so that theoretically we could create any test scene then attach
# 		the ONE requisite component and be cool

# TODO: This scene, and any "world" scene, is going to need some sort of component
# 		that handles the loading of players into it. It'll need some way to listen
# 		to players joining the game manager, and then a way to spawn them.
# 		
# 		TBD for the time being this logic could MAYBE be here, but otherwise really will
# 		want to be its own component eventually

var player_packed_scene: PackedScene = preload("res://entity/networked_player.tscn")
var camera_scene: PackedScene = preload("res://game/camera/observing_camera.tscn")
var ui_scene: PackedScene = preload("res://interface/player_user_interface.tscn")

@onready var label: Label3D = $Label3D
@onready var player_handler: Node3D = $PlayerHandler

# TODO: some problems where if the client doesn't have this there's errors when replicating. Can we just instead key in on the MultiplayerManager user spawner?
@onready var spawner: MultiplayerSpawner = $MultiplayerSpawner

func _ready() -> void:
	if multiplayer.is_server(): label.text = "Server"
	else: label.text = "Client: " + str(multiplayer.get_unique_id())
	# spawner.set_visibility_for(0, true)
	spawner.spawned.connect(_on_player_spawn)
	player_setup.rpc_id(1)

func _on_player_spawn (node: Node) -> void:
	Logger.info("Spawned New Player:" + str(node.name))
	if node is NetworkedPlayer:
		Logger.info("Client Id: " + str(node.name))
		if node.name == str(multiplayer.get_unique_id()):
			attach_camera(node)
			attach_ui(node)

@rpc("any_peer", "call_local", "reliable")
func player_setup() -> void:
	MultiplayerManager.set_state("in_world")
	var user: MultiplayerUser = MultiplayerManager.get_current_user()

	var entity: NetworkedPlayer = player_packed_scene.instantiate()
	entity.name = user.name
	entity.data = user.hero_data

	player_handler.add_child(entity, true)

	entity.client_multiplayer_id = user.id
	entity.global_position = Vector3(0, 5, 0)

	if multiplayer.is_server(): _on_player_spawn(entity)

func attach_camera (player: NetworkedPlayer) -> void:
	Logger.info("Attaching Camera?")
	var camera: ObservingCamera = camera_scene.instantiate()
	player.add_child(camera)
	player.camera = camera

func attach_ui(player: NetworkedPlayer) -> void:
	var ui: PlayerUserInterface = ui_scene.instantiate()
	player.add_child(ui)
	player.ui = ui
