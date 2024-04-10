class_name RichPlayer

extends AnimatableBody3D

@export var player_name: String
var player_id: int
var current_standing_tile: MapTile
var current_tile: MapTile
@export var player_dice: Dice = Dice.new()
@export var player_money: int = 0 # Dont directly change this, Use player_money_add or player_money_subtract
var player_estates: Array[Estate] = []

@export var debug_label: RichTextLabel

signal player_stopped_on_tile(map_tile: MapTile)

var pop_up_panel = preload("res://scenes/ui/popup_panel_with_confirmation.tscn")

@export_group("Player Estate Models")
# Model files
@export_file("*.glb") var model_level_1_file
@export_file("*.glb") var model_level_2_file
@export_file("*.glb") var model_level_3_file
@onready var model_level_1: PackedScene = load(model_level_1_file)
@onready var model_level_2: PackedScene = load(model_level_2_file)
@onready var model_level_3: PackedScene = load(model_level_3_file)

func _ready():
	current_standing_tile = $"../MapTiles/MapTile" # Debug
	current_tile = current_standing_tile
	if debug_label != null:
		debug_label_update()


func move(step: int):
	while(step > 0):
		var next_tile = current_standing_tile.get_next_tile()
		if next_tile == null:
			break
		# Transport player's position to next tile's position
		position = next_tile.position
		current_standing_tile = next_tile
		if debug_label:
			debug_label_update()
		step -= 1
		await get_tree().create_timer(0.1).timeout # Delay 1so
	
	# Finished Moving
	current_tile = get_node("../MapTiles/" + current_standing_tile.name)

	if current_standing_tile is Estate:
		var estate = current_standing_tile as Estate
		print("Enter a estate")
		if estate.owned_by == null:
			# Player can buy the estate
			print("Opening the window")
			var pop_up_panel_instance = pop_up_panel.instantiate()
			pop_up_panel_instance.description_text = "是否愿意花 $" + str(estate.base_price) + " 来购买本资产?"
			get_node("../PlayerUI").add_child(pop_up_panel_instance)

			var pop_up_manager = pop_up_panel_instance.get_node("../PopupPanelWithConfirmation")

			pop_up_manager.connect("yes", _on_Purchase_confirmation)
		if estate.owned_by == self:
			# Player can upgrade the estate
			print("Opening the window")
			var pop_up_panel_instance = pop_up_panel.instantiate()
			var upgrade_price = estate.get_upgrade_price()
			pop_up_panel_instance.description_text = "是否愿意花 $" + str(upgrade_price) + " 钱来升级本资产?"
			get_node("../PlayerUI").add_child(pop_up_panel_instance)

			var pop_up_manager = pop_up_panel_instance.get_node("../PopupPanelWithConfirmation")

			pop_up_manager.connect("yes", _on_Upgrade_confirmation)

func _on_Purchase_confirmation():
	var estate = current_standing_tile as Estate
	if player_money >= estate.base_price:
		player_money_subtract(estate.base_price)
		estate.purchase(self)
		player_estates.append(estate)
		print("Player bought the estate")
		debug_label_update()
	else:
		# TODO: Show a message to the player
		print("Player does not have enough money to buy the estate")

func _on_Upgrade_confirmation():
	var estate = current_standing_tile as Estate
	if player_money >= estate.get_upgrade_price():
		player_money_subtract(estate.get_upgrade_price())
		estate.upgrade(1)
		print("Player upgraded the estate")
		debug_label_update()
	else:
		# TODO: Show a message to the player
		print("Player does not have enough money to upgrade the estate")


func debug_label_update():
	# Multiple Line,  Player Name, Player Tile, Player Money, Player Estates, Rich Text
	debug_label.text = "Player Name: " + player_name + "\nCurrent Tile: [b][color=green]" + current_standing_tile.name + "[/color][/b]\n" + "$" + str(player_money) + "\nPlayer Estates: [b][color=green]" + str(player_estates) + "[/color][/b]"

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
