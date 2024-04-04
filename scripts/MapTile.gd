class_name MapTile

extends Node3D

@export var id: int;

@export var previous_tile: MapTile;
@export var next_tile: MapTile;

enum TileType {
	Property,
	Portal	
}

func get_next_tile():
	return next_tile;
