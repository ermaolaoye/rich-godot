class_name RichCharacter

extends AnimatableBody3D

var current_tile: MapTile
var player_dice: Dice = Dice.new()
var player_money: int = 0
var player_estates: Estate # id of the estates player currently owned

# Called when the node enters the scene tree for the first time.
func _ready():
	current_tile = $"../MapTiles/MapTile" # Debug
	pass # Replace with function body.


func move(step):
	while(step > 0):
		var next_tile = current_tile.get_next_tile()
		if next_tile == null:
			break
		# Transport player's position to next tile's position
		position = next_tile.position
		current_tile = next_tile
		step -= 1
		await get_tree().create_timer(0.1).timeout # Delay 1s
