extends Node2D


var target_scene
var opponent_manager
var in_combat = false
var player_cast_time = 0
var spell_manager

# Board State Variables
var ai_slots = [] # Storage for on board slots
var player_slots = [] # Storage for on board slots
var empty_ai_slots = []
var full_player_slots = []
var current_player_targets = []
var current_opponent_targets = []

const DEFAULT_DELAY = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target_scene = preload("res://Scenes/Graphic Elements/target.tscn")
	opponent_manager = $"../OpponentManager"
	spell_manager = $".".find_child("SpellManager")
	SignalBus.opponent_targeting_player.connect(_on_opponent_targeting_player)
	SignalBus.opponent_targeting_self.connect(_on_opponent_targeting_self)
	SignalBus.opponent_targeting_slot.connect(_on_opponent_targeting_slot)
	SignalBus.player_targeting_opponent.connect(_on_player_targeting_opponent)
	SignalBus.player_targeting_self.connect(_on_player_targeting_self)
	SignalBus.player_targeting_slot.connect(_on_player_targeting_slot)
	setup_combat("default")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func setup_combat(enemy):
	identify_slots()
	in_combat = true	
	

func _on_pass_button_pressed() -> void:
	increment_time()

func time_loop():
	start_turn()
	if(opponent_manager.cast_time == 0):
		opponent_manager.make_ai_play()
	if(player_cast_time == 0):
		return
	else:
		increment_time()
		time_loop()
		
# Function to hold to setup the end of the time step
func increment_time():
	if(player_cast_time > 0):
		player_cast_time -= 1
	elif player_cast_time < 0:
		player_cast_time = 0
		print("Player cast_time is negative") # TODO: Remove this comment
	if(opponent_manager.cast_time > 0):
		opponent_manager.cast_time -= 1
	elif opponent_manager.cast_time < 0:
		print("Opponent cast_time is negative") # TODO: Remove this comment
	delay()
	spell_manager.resolve_spells()

	
# Hold the beginning of the time increment setup
func start_turn():
	$"../CardManager/PlayerHand".draw()
	$"../OpponentManager".start_turn()
	find_empty_slots()
	find_full_slots()

func opponent_turn():
		# Make the button unclickable and invisible
	$"../PassButton".disabled = true
	$"../PassButton".visible = false
	# Initialize Opponent Turn

	$"../OpponentManager".end_turn()

func play_card(card, caster = "player", cardslot = "", player = "opponent", cast_time_mod = 0, cast_damage_mod = 0):
	pass

func player_turn():
	$"../PassButton".visible = true
	$"../PassButton".disabled = false


func _on_opponent_targeting_player(card):
	create_target(Globals.PLAYER_POSITION, false)
	print("Opponent targeting Player")

func _on_opponent_targeting_self(card):
	create_target(Globals.ENEMY_POSITION, false)
	print("Opponent targeting self")
	
func _on_opponent_targeting_slot(slot, card):
	create_target(slot.position, false)
	print("Opponent targeting slot")

func _on_player_targeting_opponent(card):
	create_target(Globals.ENEMY_POSITION, true)
	print("Player targeting self")

func _on_player_targeting_self(card):
	create_target(Globals.PLAYER_POSITION, true)
	print("Player targeting self")
	
func _on_player_targeting_slot(slot, card):
	create_target(slot.position, true)
	print("Player targeting slot")

func delay(delay = DEFAULT_DELAY):
	$BattleTimer.wait_time = delay
	$BattleTimer.start()
	await $BattleTimer.timeout
	return

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
	full_player_slots = player_slots
	for i in ai_slots:
		if (i.cards.size() == 0):
			full_player_slots.erase(i)

# Create a target at a location, allows for multiple targets per "player"
func create_target(location, player_owned = false):
	var current_target = target_scene.instantiate()
	current_target.position = location
	$".".add_child(current_target)
	if (player_owned):
		current_target.get_node("EnemySprite").visible = false
		current_target.get_node("PlayerSprite").visible = true
		current_player_targets.append(current_target)
	else:
		current_target.get_node("EnemySprite").visible = true
		current_target.get_node("PlayerSprite").visible = false
		current_opponent_targets.append(current_target)
	return

func clear_target(player_owned):
	if player_owned:
		for x in current_player_targets:
			x.free()
	else:
		for y in current_opponent_targets:
			y.free()
	return
