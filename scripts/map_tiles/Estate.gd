class_name Estate

extends MapTile

var estate_level: int = 0
@export var base_price: int
@export var debug_label: Label3D

@export var pop_up_panel: Panel

var owned_by: RichPlayer

func _ready():
	update_debug_label()

func purchase(player: RichPlayer):
	estate_level = 1
	owned_by = player
	if debug_label:
		update_debug_label()

func upgrade(level):
	estate_level += level
	if debug_label:
		update_debug_label()
	
func downgrade(level):
	estate_level -= level
	if debug_label:
		update_debug_label()

func destroy():
	estate_level = 0
	owned_by = null
	if debug_label:
		update_debug_label()

func changeOwnership(player: RichPlayer):
	owned_by = player

func update_debug_label():
	if owned_by:
		debug_label.text = "Estate Name: " + tile_name + "\n" + "Estate Level: " + str(estate_level) + "\nEstate Price: " + str(base_price) + "\n" + "Owned by: " + owned_by.player_name + "\n"
	else:
		debug_label.text = "Estate Name: " + tile_name + "\n" + "Estate Level: " + str(estate_level) + "\nEstate Price: " + str(base_price) + "\n"
