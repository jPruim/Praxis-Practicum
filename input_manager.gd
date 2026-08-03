extends Node2D


# Masks
const CARD_COLLISION_MASK = 1
const CARD_SLOT_COLLISION_MASK = 2
const DECK_COLLISION_MASK = 4

# Properties
var card_manager: CardManager
var player_deck: Deck
var player_hand
var battle_manager: BattleManager


func _ready() -> void:
	card_manager = $"../CardManager"
	player_deck = $"../CardManager/PlayerDeck"
	player_hand = $"../CardManager/PlayerHand"
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
	var card_found: CardBase = card_manager.raycast_check_for_card()
	var deck_found: Deck = card_manager.raycast_check_for_deck()
	if card_found:
		card_manager.start_drag(card_found)
	elif deck_found:
		card_manager.new_multicard_display(deck_found.deck)
	return null	
