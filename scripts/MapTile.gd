class_name MapTile

extends Node3D

@export var id: int;

@export var previous_tile: Node3D;
@export var next_tile: Node3D;

enum TileType {
	Property,
	Portal	
}

func get_next_tile():
	return next_tile;
