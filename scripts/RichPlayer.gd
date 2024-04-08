class_name RichPlayer

extends AnimatableBody3D

var player_name: String

@export var start_tile: MapTile
var current_tile: MapTile
var player_dice: Dice = Dice.new()
var player_money: int = 0
var player_estates: Array[Estate]

@export var debug_label: Label

# Called when the node enters the scene tree for the first time.
func _ready():
	current_tile = $"../MapTiles/MapTile" # Debug
	pass # Replace with function body.


func move(step: int):
	while(step > 0):
		var next_tile = current_tile.get_next_tile()
		if next_tile == null:
			break
		# Transport player's position to next tile's position
		position = next_tile.position
		current_tile = next_tile
		step -= 1
		await get_tree().create_timer(0.1).timeout # Delay 1s

func debug_update_player_money():
	debug_label.text = "Player Money: " + str(player_money) 

func player_money_add(amount: int):
	player_money += amount
	debug_update_player_money()

func player_money_subtract(amount: int):
	player_money -= amount
	debug_update_player_money()

func player_money_set(amount: int):
	player_money = amount
	debug_update_player_money()
		
func _init(player_name: String, player_money: int, start_tile: MapTile):
	self.player_name = player_name
	self.player_money = player_money
	self.start_tile = start_tile
	self.current_tile = start_tile
	self.position = start_tile.position
	debug_update_player_money()