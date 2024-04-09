class_name RichPlayer

extends AnimatableBody3D

@export var player_name: String
var current_standing_tile: MapTile
var current_tile: MapTile
@export var player_dice: Dice = Dice.new()
@export var player_money: int = 0
var player_estates: Array[Estate] = []

@export var debug_label: Label

signal player_stopped_on_tile(map_tile: MapTile)

var pop_up_panel = preload("res://scenes/ui/popup_panel_with_confirmation.tscn")

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
			pop_up_panel_instance.description_text = "Do you want to buy this estate for $" + str(estate.base_price) + "?"
			get_node("../PlayerUI").add_child(pop_up_panel_instance)

			var pop_up_manager = pop_up_panel_instance.get_node("../PopupPanelWithConfirmation")

			pop_up_manager.connect("yes", _on_Purchase_confirmation)

func _on_Purchase_confirmation():
	var estate = current_standing_tile as Estate
	if player_money >= estate.base_price:
		player_money_subtract(estate.base_price)
		estate.purchase(self)
		player_estates.append(estate)
		print("Player bought the estate")
		debug_label_update()
	else:
		print("Player does not have enough money to buy the estate")


func debug_label_update():
	# Multiple Line,  Player Name, Player Tile, Player Money
	debug_label.text = "Player Name: " + player_name + "\nCurrent Tile: " + current_standing_tile.name + "\n" + "$" + str(player_money) + "\nPlayer Estates: " + str(player_estates)

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
