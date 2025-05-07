extends Node2D


# Properties
# Card object being grabbed (NOT a bool)
var card_being_dragged = null
# store screen size
var screen_size: Vector2

# Check if hovering
var is_hovering_card :bool = false

# Masks
const CARD_COLLISION_MASK = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	
	
	pass # Replace with function body.



func _input(event: InputEvent) -> void:
	#mouse events
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				var card = raycast_check_for_card()
				if card:
					start_drag(card)
			else:
				end_drag()
			

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
	if hovered:
		card.scale = Vector2(1.05, 1.05)
		card.z_index = 2
	else:
		card.scale  = Vector2( 1, 1)
		card.z_index = 1
		
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
	card_being_dragged = null
	
	
	
