extends Node

# Will through warnings if unused_signal warning is allowed in project settings

# AI Signals
signal opponent_targeting_slot(slot: CardSlot, card: CardBase)
signal opponent_targeting_player(card: CardBase)
signal opponent_targeting_self(card: CardBase)
signal opponent_spell_resolution(rarity: String)

# Player Signals
signal player_targeting_slot(slot: CardSlot, card: CardBase)
signal player_targeting_opponent(card: CardBase)
signal player_targeting_self(card: CardBase)
signal player_spell_resolution(rarity: String)

# Keybind signals
signal left_mouse_button_clicked
signal left_mouse_button_released
signal menu_button_pressed
signal card_hovered
signal card_hovered_off
signal player_hand_hovered
signal player_hand_hovered_off


# Gamestate Signals
signal fight_start
signal fight_enter
signal fight_won(remaining_health)
signal fight_loss
signal run_win
signal run_loss
signal run_start
signal run_resume
signal shop_enter
signal shop_exit


# Shop Signals
signal buy_spell(spell)
signal sell_spell(spell)
signal buy_sigil()
signal sell_sigil


# Control Signals
signal shuffle_deck
signal player_turn(state: bool)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
