class_name CardManager
extends Node2D


# Properties
var card_being_dragged = null # Card object being grabbed (NOT a bool)
var screen_size: Vector2
var is_hovering_card :bool = false
var player_hand
var opponent_hand
var deck_scene

# Consts
const DECK_POSITION = Vector2(100, 900)/4
const OPPONENT_DECK_POSITION = Vector2(1800, 150)/4
const CARD_SCALE_PlACED = Vector2( 0.7, 0.7)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	deck_scene = preload("res://Scenes/Cards/deck.tscn")
	player_hand = $"PlayerHand"
	player_hand.ai_hand = false
	player_hand.position = Vector2(get_viewport_rect().size.x / 2, Globals.PLAYER_HAND_Y_POS)
	opponent_hand = $OpponentHand
	opponent_hand.get_node("MarginContainer").visible = false
	opponent_hand.get_node("Area2D/CollisionShape2D").disabled = true
	opponent_hand.position = Vector2(get_viewport_rect().size.x / 2, Globals.OPPONENT_HAND_Y_POS)
	opponent_hand.ai_hand = true
	screen_size = get_viewport_rect().size
	SignalBus.connect("left_mouse_button_released", on_left_click_release)
	connect_signals()
	pass # Replace with function body.

# Card Collision detector
func raycast_check_for_card():
	var result = raycast_check_mask(Globals.MASK.card)
	# if over an area
	if result.size() > 0:
		# make sure to highlight return top card only
		return get_top_card(result)
	return null	

# Card Slot Collision Detector
func raycast_check_for_card_slot():
	var result = raycast_check_mask(Globals.MASK.cardSlot)
	# if over an area
	if result.size() > 0:
		# make sure to highlight return top card only
		return result[0].collider.get_parent()
	return null	
	
func raycast_check_mask( mask: int):
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = mask
	return space_state.intersect_point(parameters)

# Player Hand Collision Detector
func raycast_check_for_player_hand():
	var result = raycast_check_mask(Globals.MASK.player_hand)
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

#Handle Signals
func connect_signals():
	SignalBus.connect("player_hand_hovered", on_hover_hand)
	SignalBus.connect("player_hand_hovered_off", on_hover_hand_off)
	
# Called by Cards Individually
func connect_card_signals(card:CardBase):
	SignalBus.connect("card_hovered", on_hovered_card)
	SignalBus.connect("card_hovered_off", on_hovered_off_card)


# Handle card being hovered
func on_hovered_card(card: CardBase):
	if !is_hovering_card:
		is_hovering_card = true
	card.card_affects( true)

# Handle card being hovered
func on_hovered_off_card(card):
	# Check if card is NOT in a card slot
	if !card_being_dragged:
		#check if transitioning onto a new card
		var new_card = raycast_check_for_card()
		if new_card:
			on_hovered_card(new_card)
		else:
			is_hovering_card = false
	# Make sure cards are in the right spot, only needed if card clamping
	$PlayerHand.update_hand_positions()
	$OpponentHand.update_hand_positions()
	# Turn off card affects
	card.card_affects(false)
	

		
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
		
func start_drag(card:CardBase):
	if(card.being_cast || card is CasterFrameBase):
		return
	card_being_dragged = card
	card_being_dragged.z_index = Globals.Z_INDEX["card_being_dragged"]
	card_being_dragged.scale = Globals.SCALE.card_drag
	
	
func end_drag():
	# Disable collision shape during animations
	# card_being_dragged.get_node("Area2D/CollisionShape2D").disabled = true
	
	var card_type = card_being_dragged.get_card_type()
	
	
	# Check if Player can cast
	if($"..".is_player_turn):
		# Check if final location is a CardSlot
		var card_slot = raycast_check_for_card_slot()
		if (card_slot && card_slot.is_player):
			if(card_being_dragged.ai_card):
				# Should never be called
				opponent_hand.remove_card_from_hand(card_being_dragged) 
			else:
				card_being_dragged.scale = Globals.SCALE.cast_scale
				player_hand.remove_card_from_hand(card_being_dragged)
				player_hand.update_hand_border(false)
			SignalBus.emit_signal("player_targeting_self", card_being_dragged)
			card_being_dragged = null
			return
		elif (card_slot && card_slot.is_opponent):
			if(card_being_dragged.ai_card):
				# Should never be called
				opponent_hand.remove_card_from_hand(card_being_dragged) 
			else:
				card_being_dragged.scale = Globals.SCALE["card_cast"]
				$PlayerHand.hovered = false
				player_hand.remove_card_from_hand(card_being_dragged)
				player_hand.update_hand_border(false)
			SignalBus.emit_signal("player_targeting_opponent", card_being_dragged)
			card_being_dragged = null
			return
		elif(card_slot and card_slot.max_cards > card_slot.cards.size()):
			# Check for room in the CardSlot
			if  (card_type == "summon" and card_slot.player_owned) or \
				(card_type == "spell"):
				#card_being_dragged.in_slot = true
				#card_being_dragged.position = card_slot.position
				card_being_dragged.scale = Globals.SCALE.card_cast
				if(card_being_dragged.ai_card):
					# Should never be called
					$PlayerHand.hovered = false
					opponent_hand.remove_card_from_hand(card_being_dragged)
					player_hand.update_hand_border(false) 
				else:
					$PlayerHand.hovered = false
					player_hand.remove_card_from_hand(card_being_dragged)
					player_hand.update_hand_border(false)
				SignalBus.emit_signal("player_targeting_slot", card_slot, card_being_dragged)
				card_being_dragged = null
				return
	
	if(card_being_dragged.ai_card):
		# Should never be called
		opponent_hand.add_card_to_hand(card_being_dragged)
	else:
		card_being_dragged.scale = Globals.SCALE.card_hand
		$PlayerHand.hovered = false
		player_hand.add_card_to_hand(card_being_dragged)
		player_hand.update_hand_border(false)
	# Re-enable Animations
	card_being_dragged.get_node("Area2D/CollisionShape2D").disabled = false
	card_being_dragged = null
	
	
func initialize_decks(run_data: RunData):
	var deck = deck_scene.instantiate()
	deck.position = DECK_POSITION
	deck.ai_deck = false
	deck.name = "PlayerDeck"
	add_child(deck)
	deck.initialize(run_data)
	deck = deck_scene.instantiate()
	deck.name = "OpponentDeck"
	deck.position = OPPONENT_DECK_POSITION
	deck.get_node("Area2D").collision_mask = Globals.MASK.deck_opponent
	deck.ai_deck = true
	add_child(deck)
	deck.initialize(run_data)

func on_hover_hand():
	$PlayerHand.hovered = true
	$PlayerHand.update_hand_border(true)
	$PlayerHand.update_hand_positions()
	
func on_hover_hand_off():
	if(raycast_check_for_player_hand()):
		# This saves miscalls when on a narrow margin at the edge of cards
		# No idea why this is needed... TODO: Solve this
		return
	if(!card_being_dragged):
		$PlayerHand.hovered = false
		$PlayerHand.update_hand_border(false)
		$PlayerHand.update_hand_positions()

func animate_hand_border(speed = Globals.DEFAULT_ASPEED):
	var tween = get_tree().create_tween()
	var position
	if($PlayerHand.hovered):
		$PlayerHand.position = Globals.PLAYER_HAND_Y_POS + $PlayerHand.offset_value
	else: 
		$PlayerHand.position = Globals.PLAYER_HAND_Y_POS
	tween.tween_property($"PlayerHand", "position", position, speed)



# Function called on Signal being received from Input Manager
func on_left_click_release():
	if card_being_dragged:
		end_drag()
		
		
