extends Button

var rng = RandomNumberGenerator.new()
var current_player: RichPlayer
var current_camera: RichCamera

@export var debug_label: Label

func _ready():
	current_player = $"../../Character" # For Test Scene Debug
	current_camera = $"../../MainCamera"

func _pressed():
	var dice_index = rng.randi_range(0, current_player.player_dice.dice_rolls.size() - 1)
	var dice_rolled = current_player.player_dice.dice_rolls[dice_index]
	current_player.move(dice_rolled)
	if debug_label != null:
		debug_update_dice_rolled(dice_rolled)
	pass

func debug_update_dice_rolled(dice_rolled):
	debug_label.text = "Dice Rolled: %s" % dice_rolled
