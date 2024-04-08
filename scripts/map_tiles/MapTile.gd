class_name MapTile

extends Node3D

@export var id: int
@export var tile_name: String

@export var next_tile: Array[MapTile]

func get_next_tile():
	if next_tile.size() == 0:
		# TODO: No Next Tiles
		pass # No next tile
	elif next_tile.size() == 1:
		return next_tile[0]
	else:
		# TODO: Multiple Next Tiles
		pass
