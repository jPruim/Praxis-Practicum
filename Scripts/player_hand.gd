extends Node2D

# Consts
const CARD_SCENE_PATH = "res://Scenes/Cards/card_base.tscn"
const CARD_WIDTH = 200
const DEFAULT_ASPEED = 0.25

# Properties
var player_hand = []
var center_screen_x: int
var ai_hand:bool = false
var offset_value: int = - 150
var hovered: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	center_screen_x = floor(get_viewport().size.x / 2)
	connect_signals()


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
	animate_hand_border()
	var y_pos
	if(ai_hand):
		y_pos = Globals.OPPONENT_HAND_Y_POS
	else:
		if(hovered):
			y_pos = Globals.PLAYER_HAND_Y_POS + offset_value
		else:
			y_pos = Globals.PLAYER_HAND_Y_POS
	for i in range(player_hand.size()):
		var new_position = Vector2(calculate_card_position(i), y_pos)
		var card = player_hand[i]
		card.hand_position = new_position
		card.animate_card_to_position(new_position, speed)
	pass

# Calculate the offset (for x) in the hand	
func calculate_card_position(i):
	# Apprently, this needs to also be defined here for the function 
	# to work on initial loading (otherwise center_screen_x is 0)
	center_screen_x = floor(get_viewport().size.x / 2) 
	var total_width = (player_hand.size() - 1) * CARD_WIDTH
	var x_offset
	
	# Reverse the directions of enemy hands
	if (!ai_hand):
		x_offset = center_screen_x + i * CARD_WIDTH - total_width / 2
	else:
		x_offset = center_screen_x - i * CARD_WIDTH + total_width / 2
	return x_offset




#Handle Signals
func connect_signals():
	SignalBus.connect("player_hand_hovered", on_hover)
	SignalBus.connect("player_hand_hovered_off", on_hover_off)

func on_hover():
	if(ai_hand):
		return
	hovered = true
	update_hand_positions()
	
func on_hover_off():
	if(ai_hand):
		return
	hovered = false
	update_hand_positions()
	
func _on_area_2d_mouse_entered() -> void:
	SignalBus.emit_signal("player_hand_hovered")
	pass # Replace with function body.


func _on_area_2d_mouse_exited() -> void:
	SignalBus.emit_signal("player_hand_hovered_off")

	pass # Replace with function body.

func animate_hand_border(speed = Globals.DEFAULT_ASPEED):
	if(ai_hand):
		return
	var tween = get_tree().create_tween()
	var position
	if(hovered):
		position = Globals.PLAYER_HAND_Y_POS + offset_value
	else: 
		position = Globals.PLAYER_HAND_Y_POS
	tween.tween_property($"Area2D", "position", position, speed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
