class_name RichCamera

extends Camera3D
	
#func _input(event):
	#if event.is_action_pressed("CameraPan"):
		#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#if event.is_action_released("CameraPan"):
		#Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

func _unhandled_input(event: InputEvent) -> void:
	# Hide Mouse When Pressed
	if event is InputEventMouseMotion:
		if event.button_mask == MOUSE_BUTTON_MASK_LEFT:
			var delta = event.relative;
			var sensitivity = 0.01
			global_translate(Vector3(-delta.x * sensitivity, 0, -delta.y * sensitivity))
			# <++> Camera Momentum?
	if event.is_action_pressed("CameraReset"):
		camera_focus_on_player()
		

func camera_focus_on(pos: Vector3):
	# <++> Camera Animation
	global_position = pos + Vector3(0, 9, 3)
	
func camera_focus_on_player():
	var root_node = get_parent()
	var char_1 = root_node.get_node("Character");
	camera_focus_on(char_1.global_position)
