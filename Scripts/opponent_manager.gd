extends Node2D


# Constants
const THOUGHT_DELAY = 0.7

# Propterties
var timer
var cast_time = 0
var ai_slots = [] # Storage for on board slots
var empty_ai_slots = []
var player_slots = [] # Storage for on board slots
var full_player_slots = []
var opponent_hand
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer = $OpponentTimer
	timer.one_shot = true
	opponent_hand = $"../CardManager/OpponentHand"
	identify_slots()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Any automatic "start of turn" affects
func start_turn():
	print("AI turn Start")
	$"../CardManager".get_node("OpponentDeck").draw_card()
	make_ai_play()

# For furture end turn effects (currently there aren't any)
func end_turn():
	print("AI turn End")
	pass

func make_ai_play():
	# Basic AI
	
	# Do nothing if hand is empty
	if (opponent_hand.player_hand.size() == 0):
		return
	# Do nothing if already casting
	if (cast_time > 0):
		return
	
	# Choose Random Card in hand
	var i = randi() % opponent_hand.player_hand.size()
	var choice = opponent_hand.player_hand.pop_at(i)
	var card_info = choice.get_card_info()
	cast_time = card_info[Globals.CARD_INFO.CAST_TIME]
	# Cast card
	if card_info[Globals.CARD_INFO.CARD_TYPE] == "summon":
		pass
	elif choice.get_card_info()[Globals.CARD_INFO.CARD_TYPE] == "spell":
		pass
	if (cast_time == 0):
		make_ai_play()

func summon_target():
	find_empty_slots()
	
	# Select Random valid target
	var target = empty_ai_slots[randi() % empty_ai_slots.size()]
	return target
	
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



func find_empty_slots():
	empty_ai_slots = ai_slots
	for i in ai_slots:
		if (i.cards.size() > 0):
			empty_ai_slots.erase(i)

func find_full_slots():
	full_player_slots = ai_slots
	for i in ai_slots:
		if (i.cards.size() == 0):
			full_player_slots.erase(i)

# Time function
func decision_delay(delay = THOUGHT_DELAY):
	timer.wait_time = delay
	timer.start()
	await timer.timeout
	return
