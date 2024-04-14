class_name GameMode
extends Node

signal player_spawned()

@export var player_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	generate_player_on_spawning_tile()

func generate_player(spawn_tile: MapTile, player_name: String, id: int):
	var player_instance = player_scene.instantiate()
	player_instance.name = str(id)
	player_instance.player_name = player_name
	player_instance.position = spawn_tile.position
	player_instance.current_tile = spawn_tile
	player_instance.current_standing_tile = spawn_tile
	player_instance.player_money = 10000

	if id == multiplayer.get_unique_id():
		player_instance.debug_label = $"/root/GameScene/DebugUI/PlayerDebug"
	$Players.add_child(player_instance)
	


func generate_player_on_spawning_tile():
	var index = 0
	var spawn_tiles = get_tree().get_nodes_in_group("PlayerSpawn")
	spawn_tiles.shuffle()
	for i in GameManager.players:
		var player_name = GameManager.players[i]["player_name"]
		generate_player(spawn_tiles[index], player_name, i)
		index += 1
	player_spawned.emit()
