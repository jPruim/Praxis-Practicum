extends Node2D


# Masks
const CARD_COLLISION_MASK = 1
const CARD_SLOT_COLLISION_MASK = 2
const DECK_COLLISION_MASK = 4

# Properties
var player_deck: Deck
var player_hand
var battle_manager: BattleManager


func _ready() -> void:
	player_hand = CardManager.get_node("PlayerHand")
	battle_manager = $"../"

func _input(event: InputEvent) -> void:
	#mouse events
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				raycast_check_at_cursor()
				SignalBus.emit_signal("left_mouse_button_clicked")
			else:
				SignalBus.emit_signal("left_mouse_button_released")
				pass
			

func raycast_check_at_cursor():
	var card_found: CardBase = CardManager.raycast_check_for_card()
	var deck_found: Deck = CardManager.raycast_check_for_deck()
	player_deck = CardManager.get_node("PlayerDeck")
	if card_found:
		CardManager.start_drag(card_found)
	elif deck_found:
		CardManager.new_multicard_display(deck_found.deck)
	return null	
