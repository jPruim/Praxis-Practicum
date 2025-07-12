extends Node2D


# Masks
const CARD_COLLISION_MASK = 1
const CARD_SLOT_COLLISION_MASK = 2
const DECK_COLLISION_MASK = 4

# Properties
var card_manager
var player_deck
var player_hand


func _ready() -> void:
	card_manager = $"../CardManager"
	player_deck = $"../CardManager/PlayerDeck"
	player_hand = $"../PlayerHand"
	

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
	var card_found = card_manager.raycast_check_for_card()
	if card_found:
		card_manager.start_drag(card_found)
	return null	
