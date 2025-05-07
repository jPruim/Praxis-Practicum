extends Node2D


#properties
#Card object being grabbed (NOT a bool)
var card_being_dragged = null
#store screen size
var screen_size
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
					card_being_dragged = card
			else:
				card_being_dragged = null
			

# Card Collision detector
func raycast_check_for_card():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = CARD_COLLISION_MASK
	var result = space_state.intersect_point(parameters)
	
	#if over an area
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	#set dragged card to mouse position
	if card_being_dragged:
		var mouse_pos = get_global_mouse_position()
		card_being_dragged.position = Vector2(clamp(mouse_pos.x, 0, screen_size.x),clamp(mouse_pos.y, 0, screen_size.y))		
	pass
