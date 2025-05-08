extends Node2D


# Properties
var card_being_dragged = null # Card object being grabbed (NOT a bool)
var screen_size: Vector2
var is_hovering_card :bool = false
var player_hand

# Masks
const CARD_COLLISION_MASK = 1
const CARD_SLOT_COLLISION_MASK = 2

const DECK_POSITION = Vector2(100, 900)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_hand = $"../PlayerHand"
	screen_size = get_viewport_rect().size
	$"../InputManager".connect("left_mouse_button_released", on_left_click_release)
	$"../Deck".position = DECK_POSITION
	
	pass # Replace with function body.

# Card Collision detector
func raycast_check_for_card():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = CARD_COLLISION_MASK
	var result = space_state.intersect_point(parameters)
	
	# if over an area
	if result.size() > 0:
		# make sure to highlight return top card only
		return get_top_card(result)
	return null	

# Card Slot Collision Detector
func raycast_check_for_card_slot():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = CARD_SLOT_COLLISION_MASK
	var result = space_state.intersect_point(parameters)
	
	# if over an area
	if result.size() > 0:
		# make sure to highlight return top card only
		return result[0].collider.get_parent()
	return null	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	#set dragged card to mouse position
	if card_being_dragged:
		var mouse_pos = get_global_mouse_position()
		card_being_dragged.position = Vector2(clamp(mouse_pos.x, 0, screen_size.x),clamp(mouse_pos.y, 0, screen_size.y))		
	pass

#Handle card Signals
func connect_card_signals(card):
	card.connect("hovered", on_hovered_card)
	card.connect("hovered_off", on_hovered_off_card)

# Handle card being hovered
func on_hovered_card(card):
	if !is_hovering_card:
		is_hovering_card = true
		card_affects(card, true)

# Handle card being hovered
func on_hovered_off_card(card):
	if !card_being_dragged:
		card_affects(card, false)
		#check if transitioning onto a new card
		var new_card = raycast_check_for_card()
		if new_card:
			card_affects(new_card, true)
		else:
			is_hovering_card = false
	
# Change card affects
func card_affects(card, hovered: bool):
	var animation_sprite = card.get_node("Container").get_node("AnimatedSprite2D")
	if hovered:
		card.scale = Vector2(1.05, 1.05)
		card.z_index = 10
		# Play Animation
		animation_sprite.play()
	else:
		card.scale  = Vector2( 1, 1)
		card.z_index = 1
		# Pause Animation
		animation_sprite.pause()
		
# Returns the top card from a raycast result
func get_top_card(results):
	# Should NEVER pass, but error check
	if !results:
		print("called get_top_card() on Null")
		return
		
	# Calculate the top card (by z-index), if in doubt, choose "default" order
	var top_card = results[0].collider.get_parent()
	var check_card
	for i in range(1, results.size()):
		check_card = results[i].collider.get_parent()
		if check_card.z_index > top_card.z_index:
			top_card = check_card
	return top_card
		
func start_drag(card):
	card_being_dragged = card
	card_being_dragged.scale = Vector2( 1, 1)
	
	
func end_drag():
	card_being_dragged.scale = Vector2( 1.05, 1.05)
	
	# Check if final location is a CardSlot
	var card_slot = raycast_check_for_card_slot()
	# Check for room in the CardSlot
	if card_slot and card_slot.max_cards > card_slot.cards.size():
		print("Placed card in slot")
		card_being_dragged.position = card_slot.position
		card_being_dragged.get_node("Area2D/CollisionShape2D").disabled = true
		
		# Add card to card slot and remove from hand (THIS ASSUMES CARD CAME FROM HAND)
		card_slot.cards.append(card_being_dragged)
		player_hand.remove_card_from_hand(card_being_dragged)
	else:
		player_hand.add_card_to_hand(card_being_dragged)
	card_being_dragged = null
	
# Function called on Signal being received from Input Manager
func on_left_click_release():
	if card_being_dragged:
		end_drag()
		
		
