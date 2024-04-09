class_name RichPlayer

extends AnimatableBody3D

@export var player_name: String
var current_tile: MapTile
@export var player_dice: Dice = Dice.new()
@export var player_money: int = 0
var player_estates: Array[Estate]

@export var debug_label: Label

signal player_stopped_on_tile(map_tile: MapTile)

# Called when the node enters the scene tree for the first time.
func _ready():
	current_tile = $"../MapTiles/MapTile" # Debug
	if debug_label != null:
		debug_label_update()


func move(step: int):
	while(step > 0):
		var next_tile = current_tile.get_next_tile()
		if next_tile == null:
			break
		# Transport player's position to next tile's position
		position = next_tile.position
		current_tile = next_tile
		if debug_label:
			debug_label_update()
		step -= 1
		await get_tree().create_timer(0.1).timeout # Delay 1s
	player_stopped_on_tile.emit(current_tile)
	

func debug_label_update():
	# Multiple Line,  Player Name, Player Tile, Player Money
	debug_label.text = "Player Name: " + player_name + "\nCurrent Tile: " + current_tile.name + "\n" + "$" + str(player_money)

func player_money_add(amount: int):
	player_money += amount
	if debug_label:
		debug_label_update()

func player_money_subtract(amount: int):
	player_money -= amount
	if debug_label:
		debug_label_update()

func player_money_set(amount: int):
	player_money = amount
	if debug_label:
		debug_label_update()
