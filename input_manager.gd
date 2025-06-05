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
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	var result = space_state.intersect_point(parameters)
	
	# if over an area
	if result.size() > 0:
		var collision_mask = result[0].collider.collision_mask
		if collision_mask == Globals.CARD_COLLISION_MASK:
				# Cursor on Card
			var card_found = result[0].collider.get_parent()
			if card_found:
				card_manager.start_drag(card_found)
		elif collision_mask == Globals.DECK_COLLISION_MASK:
			print(result[0])
			# Cursor on Deck
			player_deck.draw_card()
	return null	
