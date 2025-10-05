class_name OpponentManager
extends Node2D


# Constants
const THOUGHT_DELAY = 0.7

# Propterties
var timer
var cast_time = 0
var spell_manager: SpellManager
var opponent_hand: PlayerHand
var battle_manager: BattleManager
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer = $OpponentTimer
	timer.one_shot = true
	opponent_hand = $"../CardManager/OpponentHand"
	battle_manager = $"../"
	spell_manager = $"../SpellManager"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Any automatic "start of turn" affects (e.g. draw a card)
func start_turn():
	print("AI turn Start")
	$"../CardManager".get_node("OpponentDeck").draw_card()

# For furture end turn effects (currently there aren't any)
func end_turn():
	print("AI turn End")
	pass

func make_ai_play():
	# Basic AI
	decision_delay()
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
	cast_time = card_info.cast_time
	# Cast card
	if card_info.card_type == "summon":
		summon_target(choice)
		pass
	elif card_info.card_type == "spell":
		spell_target(choice)
		pass
	spell_manager.cast(choice, false)
	opponent_hand.update_hand_positions()
	if (cast_time == 0):
		battle_manager.delay()
		make_ai_play()



func summon_target(card: CardBase):
	var valid_targets: Array[CardSlot] = []
	for slot in battle_manager.ai_slots:
		if($"../SpellManager".check_stacking_summon(card, slot)):
			# Always stack summons when possible
			valid_targets = [slot]
			break
		if($"../SpellManager".check_valid_summon(card, slot)):
			valid_targets.append(slot)
	if(valid_targets.size() == 0):
		# TODO: Make sure that there is never an enemy with more than 3 types of summons
		return
		
	var target = valid_targets[randi() % valid_targets.size()]
	SignalBus.opponent_targeting_slot.emit(target, card)
	return

func spell_target(card):
	battle_manager.find_full_slots()
	
	# TODO: Make this "smart"
	if (randi() % 2 == 0 || battle_manager.full_player_slots.size() == 0):
		# Target Opponent
		SignalBus.opponent_targeting_player.emit(card) 
	else: # Target A summon
		# Select Random valid target TODO: Make an actually AI choice
		var target = battle_manager.full_player_slots[randi() % battle_manager.full_player_slots.size()]
		SignalBus.opponent_targeting_slot.emit(target, card) 
	return


# Time function
func decision_delay(delay = THOUGHT_DELAY):
	timer.wait_time = delay
	timer.start()
	await timer.timeout
	return
