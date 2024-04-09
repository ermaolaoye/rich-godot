class_name MapTile

extends Node3D

@export var id: int
@export var tile_name: String

@export var next_tile: MapTile

func _ready():
	# If not set name, set it to the node name
	if tile_name == null:
		tile_name = get_name()

func get_next_tile():
	return next_tile
