extends Button

var rng = RandomNumberGenerator.new()
var current_player: Character
var current_camera: RichCamera

func _ready():
	current_player = $"../../Character" # For Test Scene Debug
	current_camera = $"../../MainCamera"

func _pressed():
	var dice_index = rng.randi_range(0, current_player.player_dice.dice_rolls.size() - 1)
	print(current_player.player_dice.dice_rolls[dice_index])
	current_player.move(current_player.player_dice.dice_rolls[dice_index])
	pass
