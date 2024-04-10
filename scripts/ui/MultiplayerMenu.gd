extends Control

@onready var address_text_edit: TextEdit = $TextEditServerIP
@onready var player_name_text_edit: TextEdit = $TextEditPlayerName
@onready var debug_server_label: Label = $LabelDebugServer
@onready var debug_players_label: Label = $LabelDebugPlayers

@export var port = 8910

var peer: ENetMultiplayerPeer

var player: RichPlayer = preload("res://scenes/player.tscn").instantiate()

func _ready():
	multiplayer.allow_object_decoding = true
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_disconnect_from_server)
	player.player_name = player_name_text_edit.text
	

func _on_peer_connected(id):
	print("Peer connected: ", str(id))

func _on_peer_disconnected(id):
	print("Peer disconnected: ", str(id))

func _on_connected_to_server():
	debug_server_label.text = "Connected to server: " + address_text_edit.text
	print(player is RichPlayer)
	send_player_information.rpc_id(1, player)

func _on_disconnect_from_server():
	print("Disconnected from server")


func _on_host_pressed():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 4)
	if error != OK:
		print("Error creating server: ", error)
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER) # Compress the data

	multiplayer.set_multiplayer_peer(peer)

func _on_start_game_pressed():
	start_game.rpc()

@rpc("any_peer", "call_local")
func start_game():
	# Create the game scene
	var game_scene = load("res://scenes/test_scenes/test_scene.tscn").instantiate()
	get_tree().get_root().add_child(game_scene)

	# Remove the current scene
	queue_free()

@rpc("any_peer", "call_local")
func send_player_information(send_player: RichPlayer):
	print("Received player information: ", send_player.player_name)
	if GameManager.players.has(send_player.player_id):
		GameManager.players[send_player.player_id].player_name = send_player.player_name
	else:
		GameManager.players[send_player.player_id] = send_player
	
	print(str(GameManager.players))
	for i in GameManager.players:
		debug_players_label.text += GameManager.players[i].player_name + "\n"

	
	if multiplayer.is_server():
		for i in GameManager.players:
			send_player_information.rpc(GameManager.players[i])


func _on_connect_pressed():
	peer = ENetMultiplayerPeer.new()
	player.player_id = peer.get_unique_id()
	peer.create_client(address_text_edit.text, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER) # Compress the data
	multiplayer.set_multiplayer_peer(peer)

func _on_text_edit_player_name_text_set():
	player.player_name = player_name_text_edit.text
	player.name = player_name_text_edit.text
