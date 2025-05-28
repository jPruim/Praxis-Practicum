extends Node2D

# Consts
const CARD_SCENE_PATH = "res://Scenes/Cards/card_base.tscn"
const CARD_WIDTH = 200
const PLAYER_HAND_Y_POS = 900
const DEFAULT_ASPEED = 0.25

# Properties
var player_hand = []
var center_screen_x: int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	center_screen_x = floor(get_viewport().size.x / 2)



# Add card to player hand
func add_card_to_hand(card, speed = DEFAULT_ASPEED):
	card.z_index = Globals.Z_INDEX["card_being_dragged"]
	if card not in player_hand:
		player_hand.insert(0,card)
	# Always edit hand positions
	update_hand_positions(speed)
	card.z_index = Globals.Z_INDEX["card"]
	pass

# Remove Card from player_hand
func remove_card_from_hand(card):
	if card in player_hand:
		player_hand.erase(card)
		update_hand_positions()
	pass

# update_hand_position
func update_hand_positions( speed = DEFAULT_ASPEED):
	for i in range(player_hand.size()):
		var new_position = Vector2(calculate_card_position(i), PLAYER_HAND_Y_POS)
		var card = player_hand[i]
		card.hand_position = new_position
		animate_card_to_position(card, new_position, speed)
	pass

# Calculate the offset (for x) in the hand	
func calculate_card_position(i):
	# Apprently, this needs to also be defined here for the function 
	# to work on initial loading (otherwise center_screen_x is 0)
	center_screen_x = floor(get_viewport().size.x / 2) 
	var total_width = (player_hand.size() - 1) * CARD_WIDTH
	var x_offset = center_screen_x + i * CARD_WIDTH - total_width / 2
	return x_offset


# Animations

# Animate card to position
func animate_card_to_position(card, position, speed = DEFAULT_ASPEED):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", position, speed)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
