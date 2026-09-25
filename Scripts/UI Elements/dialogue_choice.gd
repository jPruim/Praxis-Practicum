class_name DialogueChoice
extends HBoxContainer

@export var option_text: String = "Default"
@export var choice: int = 0
@onready var button = $DialogueButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_button_label(option_text)
	pass # Replace with function body.


## Set Button Text
func set_button_label(str: String):
	button.text = str
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_dialogue_button_pressed() -> void:
	SignalBus.emit_signal("dialogue_choice", choice)
	pass # Replace with function body.
