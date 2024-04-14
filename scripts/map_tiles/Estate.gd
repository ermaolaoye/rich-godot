class_name Estate

extends MapTile

@export var estate_level: int = 0
@export var max_estate_level: int = 3
@export var base_price: int
@export var upgrade_gain_by_level: float
@export var debug_label: Label3D
@export var spawn_left: bool # 1 for left, 0 for righht

var model_level_1
var model_level_2
var model_level_3

var spawn_location

@export var owned_by: RichPlayer
@export var owned: bool = false

func _ready():
	if spawn_left:
		spawn_location = get_node("SpawnHouseLocation/Left").position
	else:
		spawn_location = get_node("SpawnHouseLocation/Right").position
	
	# Add models to the scene
	update_debug_label()


func purchase(player: RichPlayer):
	estate_level = 1
	owned_by = player
	owned = true
	model_level_1 = player.model_level_1.instantiate()
	model_level_2 = player.model_level_2.instantiate()
	model_level_3 = player.model_level_3.instantiate()
	model_level_1.position = spawn_location
	model_level_2.position = spawn_location
	model_level_3.position = spawn_location
	add_child(model_level_1)
	add_child(model_level_2)
	add_child(model_level_3)
	model_level_1.visible = false
	model_level_2.visible = false
	model_level_3.visible = false
	update_model()
	if debug_label:
		update_debug_label()

func upgrade(level):
	estate_level += level
	update_model()
	if debug_label:
		update_debug_label()
	
func downgrade(level):
	estate_level -= level
	update_model()
	if debug_label:
		update_debug_label()

func destroy():
	estate_level = 0
	owned_by = null
	owned = false
	update_model()
	model_level_1 = null
	model_level_2 = null
	model_level_3 = null
	if debug_label:
		update_debug_label()

func changeOwnership(player: RichPlayer):
	owned = true
	owned_by = player

func get_upgrade_price():
	if estate_level == 0:
		return base_price
	else:
		return base_price * (estate_level + 1) * upgrade_gain_by_level

func update_debug_label():
	if owned_by:
		debug_label.text = "Estate Name: " + tile_name + "\n" + "Estate Level: " + str(estate_level) + "\nEstate Price: " + str(base_price) + "\n" + "Owned by: " + owned_by.player_name + "\n" + "Upgrade Price: " + str(get_upgrade_price()) + "\n"
	else:
		debug_label.text = "Estate Name: " + tile_name + "\n" + "Estate Level: " + str(estate_level) + "\nEstate Price: " + str(base_price) + "\n" + "Owned by: None" + "\n" + "Upgrade Price: " + str(get_upgrade_price()) + "\n"

func update_model():
	if estate_level == 0:
		model_level_1.visible = false
		model_level_2.visible = false
		model_level_3.visible = false
	elif estate_level == 1:
		model_level_1.visible = true
		model_level_2.visible = false
		model_level_3.visible = false
	elif estate_level == 2:
		model_level_1.visible = false
		model_level_2.visible = true
		model_level_3.visible = false
	elif estate_level == 3:
		model_level_1.visible = false
		model_level_2.visible = false
		model_level_3.visible = true
	else:
		model_level_1.visible = false
		model_level_2.visible = false
		model_level_3.visible = true
