extends Node

# Will through warnings if unused_signal warning is allowed in project settings

# AI Signals
signal opponent_targeting_slot(slot, card)
signal opponent_targeting_player(card)
signal opponent_targeting_self(card)
signal opponent_spell_resolution(rarity)

# Player Signals
signal player_targeting_slot(slot, card)
signal player_targeting_opponent(card)
signal player_targeting_self(card)
signal player_spell_resolution(rarity)

# Keybind signals
signal left_mouse_button_clicked
signal left_mouse_button_released
signal card_hovered
signal card_hovered_off
signal player_hand_hovered
signal player_hand_hovered_off


# Gamestate Signals
signal fight_start
signal fight_won(remaining_health)
signal fight_loss
signal run_win
signal run_loss
signal enter_shop
signal exit_shop
signal start_run

# Shop Signals
signal buy_spell(spell)
signal sell_spell(spell)
signal buy_sigil()
signal sell_sigil


# Control Signals


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
