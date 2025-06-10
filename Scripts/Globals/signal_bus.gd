extends Node

# Will through warnings if unused_signal warning is allowed in project settings

# AI Signals
signal opponent_targeting_slot(slot, card)
signal opponent_targeting_player(card)
signal opponent_targeting_self(card)

# Player Signals
signal player_targeting_slot(slot, card)
signal player_targeting_opponent(card)
signal player_targeting_self(card)

# Keybind signals
signal left_mouse_button_clicked
signal left_mouse_button_released
signal hovered
signal hovered_off


# Shop Signals

# Control Signals


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
