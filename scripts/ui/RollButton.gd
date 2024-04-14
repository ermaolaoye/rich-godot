extends Button

var rng = RandomNumberGenerator.new()
var current_player: RichPlayer
var current_camera: RichCamera


@export var debug_label: Label

func _ready():
	visible = false
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


func _on_game_scene_player_spawned():
	var current_id: int = multiplayer.get_unique_id()
	print("current id: " + str(current_id))
	current_player = get_node("/root/GameScene/Players/" + str(current_id))
	print(current_player)
	visible = true
