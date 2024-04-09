extends Panel

@export var description_label: Label
var description_text: String = ""
signal yes
signal no

func _ready():
	description_label.text = description_text

func _on_yes_button_pressed():
	yes.emit()
	queue_free()


func _on_no_button_pressed():
	no.emit()
	queue_free()
