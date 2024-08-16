class_name _MultiplayerManager extends Node

signal on_new_player

@onready var spawner: MultiplayerSpawner = $MultiplayerSpawner
@onready var users: Node = $Users
var peer: ENetMultiplayerPeer

const default_hero: HeroData = preload("res://implementation/hero/warrior_hero_definition.tres")
const user_scene = preload("res://game/manager/multiplayer_user.tscn")

func _ready() -> void:
	# TODO: we have these methods, very nice but we need MORE to be handled from these
	multiplayer.peer_connected.connect(on_player_connected)
	multiplayer.peer_disconnected.connect(on_player_disconnected)
	multiplayer.connected_to_server.connect(on_connected_to_server)
	multiplayer.connection_failed.connect(on_connection_failed)
	multiplayer.server_disconnected.connect(on_server_disconnected)

	spawner.spawned.connect(_on_user_spawn)

func _on_user_spawn(node: Node) -> void:
	Logger.info("Spawned New User:" + str(node.name))

func host_game(port: int) -> void:
	peer = ENetMultiplayerPeer.new()
	var error := peer.create_server(port)
	if error != OK: 
		# TODO: should probably signal an error to the caller
		print('cannot host: ', error)
		return

	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	add_user(1) # manually call to add_user for ourselves as the host
	var server_node: Node = Node.new()
	server_node.name = "Server-Instance"
	get_tree().root.add_child(server_node)

func join_game(address: String, port: int) -> void:
	peer = ENetMultiplayerPeer.new()
	var error: int = peer.create_client(address, port)
	if error:
		print('failed to connect: ', error)
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	var client_node: Node = Node.new()
	client_node.name = "Client-Instance-" + str(multiplayer.get_unique_id())
	get_tree().root.add_child(client_node)

# called only from clients
func on_connection_failed() -> void:
	Logger.error("failed to connect to server")

# this gets called on server and clients
func on_player_connected(id: int) -> void:
	Logger.info("NetworkedPlayer Connected: " + str(id))
	if multiplayer.is_server(): add_user(id)

# this gets called on server and clients
func on_player_disconnected(id: int) -> void:
	Logger.warn("NetworkedPlayer Disconnected: " + str(id))

func on_server_disconnected() -> void:
	Logger.warn('server disconnected')

# called only from clients
func on_connected_to_server() -> void:
	Logger.info("connected to server")

func get_current_user () -> MultiplayerUser:
	var id: int = 1
	if multiplayer.is_server():
		var remote_id: int = multiplayer.get_remote_sender_id()
		id = 1 if remote_id == 0 else multiplayer.get_remote_sender_id()
	else:
		id = multiplayer.get_unique_id()

	return get_user(id)

func get_user (id: int) -> MultiplayerUser:
	if users.has_node(str(id)):
		return users.get_node(str(id))
	return null

@rpc("any_peer")
func set_state(state: String) -> void:
	var user: MultiplayerUser = get_current_user()
	user.state = state

# TODO: what's annoying is that we can't send objects across the wire, which could be huge 
#       - using abilities by id (this is solved like the Resolvable from back in the day
@rpc("any_peer")
func add_user (id: int) -> void:
	if users.has_node(str(id)): 
		Logger.error("Cannot add player with id: " + str(id) + " because it already exists!")
		return
	Logger.info("Adding User: " + str(id))
	var user: MultiplayerUser = user_scene.instantiate()
	user.id = id
	user.name = str(id)
	users.add_child(user, true)

# TODO: in addition to "create_new_player" I'd want "load_player_data" which knows how to serialize/deserialize a HeroData payload from a client
@rpc("any_peer", "call_local", "reliable")
func create_new_player (params: Dictionary) -> void:
	var user: MultiplayerUser = get_current_user()
	Logger.info("Create NetworkedPlayer Data for: " + str(user))

	# default hero; OR passed hero definition
	var hero_data: HeroData = default_hero.duplicate()
	if (params.hero_definition):
		Logger.info("Create Hero Definition from: " + str(params.hero_definition))
		hero_data = load(params.hero_definition).duplicate()

	# default name; OR passed player name
	hero_data.name = "Josh"
	if (params.player_name):
		hero_data.name = params.player_name

	user.hero_data = hero_data

	# var hero_instance: HeroData = hero_data.duplicate()
	# hero_instance.name = params.player_name

# TODO: I need a way for a user to retrieve their player data (or really any player's data - but especially theirs)
