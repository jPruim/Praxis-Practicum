extends Node2D


# Constants
const THOUGHT_DELAY = 0.7

# Propterties
var timer
var is_casting = false
var ai_slots = [] # Storage for on board slots
var player_slots = [] # Storage for on board slots
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer = $OpponentTimer
	timer.one_shot = true
	identify_slots()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Any automatic "start of turn" affects
func start_turn():
	$"../CardManager".get_node("OpponentDeck").draw_card()
	if is_casting:
		return
	else:
		make_ai_play()

func make_ai_play():
	# Basic AI
	
	# Choose Random Card in hand
	var i = randi() % $"../OpponentHand".player_hand.size
	var choice = $"../OpponentHand".player_hand.pop_at(i)
	
	


# Theoretically only needs to be called once, 
func identify_slots():
	var card_slot = preload("res://Scenes/Cards/card_slot.tscn")
	for i in $"..".get_children():
		if i is CardSlot:
			if !i.player_owned:
				ai_slots.append(i)
			elif i.player_owned:
				player_slots.append(i)
	return

# Time function
func decision_delay(delay = THOUGHT_DELAY):
	timer.wait_time = delay
	timer.start()
	await timer.timeout
	return
