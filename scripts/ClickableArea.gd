extends Area3D

@export var clickable_mesh: MeshInstance3D
@export var debug_label: Label3D

# Called when the node enters the scene tree for the first time.
func _ready():
	debug_label.visible = false

func _mouse_enter():
	# Set Albedo Color to transparent white
	clickable_mesh.material_override.next_pass.set("shader_parameter/albedo_color", Vector4(1, 1, 1, 0.3))
	debug_label.visible = true

func _mouse_exit():
	clickable_mesh.material_override.next_pass.set("shader_parameter/albedo_color", Vector4(1, 1, 1, 0))
	debug_label.visible = false
