class_name BattleManager
extends Node2D


var target_scene
var opponent_manager: OpponentManager
var in_combat = false
var player_cast_time = 0
var spell_manager: SpellManager
var is_player_turn: bool = false
# Board State Variables
var ai_slots = [] # Storage for on board slots
var player_slots = [] # Storage for on board slots
var empty_ai_slots = []
var full_player_slots = []
var current_player_targets = []
var current_opponent_targets = []
var pass_button_path = "Playspace/PassButton"
var caster_frame_base_scene = preload("res://Scenes/Cards/caster_frame_base.tscn")
var player: CasterFrameBase
var enemy: CasterFrameBase
const DEFAULT_DELAY = 1
var phase_list = ["start_turn","ai_decision", "player_decision","cleanup", "end_step"]
var phase: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_viewport().set_physics_object_picking_sort(true)
	get_viewport().set_physics_object_picking_first_only(true)	
	target_scene = preload("res://Scenes/Graphic Elements/target.tscn")
	opponent_manager = $"OpponentManager"
	spell_manager = $".".find_child("SpellManager")
	SignalBus.opponent_targeting_player.connect(_on_opponent_targeting_player)
	SignalBus.opponent_targeting_self.connect(_on_opponent_targeting_self)
	SignalBus.opponent_targeting_slot.connect(_on_opponent_targeting_slot)
	SignalBus.player_targeting_opponent.connect(_on_player_targeting_opponent)
	SignalBus.player_targeting_self.connect(_on_player_targeting_self)
	SignalBus.player_targeting_slot.connect(_on_player_targeting_slot)
	SignalBus.player_turn.connect(_player_turn_changed)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_player_turn(state: bool):
	SignalBus.emit_signal("player_turn", state)

func _player_turn_changed(state: bool):
	is_player_turn = state

func setup_combat(run_data: RunData):
	identify_slots()
	in_combat = true
	$GameTime.set_time(3)
	setup_player(run_data)
	var enemy = run_data.assignment_list[run_data.assignment - 1]
	var enemy_data = DataManager.load_enemy_game_data(enemy)
	setup_enemy(enemy_data)
	$CardManager.initialize_decks(run_data)
	phase = "start_turn"
	time_loop()

func setup_player(run_data: RunData):
	player = caster_frame_base_scene.instantiate()
	player.set_aloction()
	player.set_default_data()
	player.z_index = Globals.Z_INDEX["caster_frame"]
	player.scale = Globals.CARD_SCALE_PlACED
	player.set_display_name(run_data.name)
	player.set_animation("Adventurer")
	player.set_health(run_data.current_health)
	player.position = Globals.PLAYER_POSITION
	player.in_slot = true
	$"Playspace/PlayerSlot".cards.append(player)
	player.animation_reveal()
	$".".add_child(player)

func setup_enemy(enemy_data: RunData):
	enemy = caster_frame_base_scene.instantiate()
	enemy.set_aloction()
	enemy.set_default_data()
	enemy.z_index = Globals.Z_INDEX["caster_frame"]
	enemy.scale = Globals.SCALE.card_placed
	enemy.set_display_name(enemy_data.name)
	enemy.set_animation("Adventurer")
	enemy.position = Globals.ENEMY_POSITION
	enemy.set_health(enemy_data.current_health)
	enemy.in_slot = true
	$"Playspace/OpponentSlot".cards.append(enemy)
	enemy.animation_reveal()
	$".".add_child(enemy)

func _on_pass_button_pressed() -> void:
	get_node(pass_button_path).disabled = true
	increment_time()

# Game Phase Setup
func next_phase():
	if(in_combat):
		phase = phase_list[1 + phase_list.find(phase) % phase_list.size()]

func time_loop():
	in_combat = true
	print_status()
	delay()
	if(phase == "start_turn"):
		start_turn()
		next_phase()
	elif(phase == "ai_decision"):
		if(opponent_manager.cast_time == 0):
			opponent_manager.make_ai_play()
			next_phase()
	elif(phase == "player_decision"):
		if(player_cast_time == 0):
			set_player_turn(true)
			# Break loop if player needs to cast something
			print_status()
			return 
	elif(phase == "clean_up"):
		increment_time() # Spell resolution
		clean_up()
	elif(phase == "end_step"):
		end_step()
	time_loop()


# Any end step effects
func end_step():
	time_loop()



		
# Function to hold to setup the end of the time step
func increment_time():
	if(player_cast_time > 0):
		player_cast_time -= 1
	elif player_cast_time < 0:
		player_cast_time = 0
		printerr("Player cast_time is negative") # TODO: Remove this comment
	if(opponent_manager.cast_time > 0):
		opponent_manager.cast_time -= 1
	elif opponent_manager.cast_time < 0:
		printerr("Opponent cast_time is negative") # TODO: Remove this comment
	delay()
	spell_manager.resolve_spells()

	
# Hold the beginning of the time increment setup
func start_turn():
	$"CardManager/".get_node("PlayerDeck").draw_card()
	$"OpponentManager".start_turn()
	$"CardManager/PlayerHand".update_hand_positions()
	$"CardManager/OpponentHand".update_hand_positions()
	find_empty_slots()
	update_button_status()
	find_full_slots()

func update_button_status():
	if player_cast_time == 0:
		get_node(pass_button_path).disabled = false

func opponent_turn():
		# Make the button unclickable and invisible
	$"../PassButton".disabled = true
	$"../PassButton".visible = false
	# Initialize Opponent Turn

	$"../OpponentManager".end_turn()

func play_card(card, caster = "player", cast_time_mod = 0, cast_damage_mod = 0):
	pass

func player_turn():
	$"../PassButton".visible = true
	$"../PassButton".disabled = false


func _on_opponent_targeting_player(card: CardBase):
	card.being_cast = true
	create_target(Globals.PLAYER_POSITION, false)
	spell_manager.cast(card, false)
	

func _on_opponent_targeting_self(card: CardBase):
	card.being_cast = true
	create_target(Globals.ENEMY_POSITION, false)
	spell_manager.cast(card, false)
	
func _on_opponent_targeting_slot(slot: CardSlot, card: CardBase):
	card.being_cast = true
	create_target(slot.position, false)
	spell_manager.cast(card, false)


func _on_player_targeting_opponent(card: CardBase):
	card.being_cast = true
	create_target(Globals.ENEMY_POSITION, true)
	spell_manager.cast(card, true)
	is_player_turn = false
	next_phase()
	time_loop()


func _on_player_targeting_self(card: CardBase):
	card.being_cast = true
	create_target(Globals.PLAYER_POSITION, true)
	spell_manager.cast(card, true)
	is_player_turn = false
	next_phase()
	time_loop()
	
func _on_player_targeting_slot(slot: CardSlot, card: CardBase):
	card.being_cast = true
	create_target(slot.position, true)
	spell_manager.cast(card, true)
	is_player_turn = false
	next_phase()
	time_loop()

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

func clean_up():
	# TODO make this actually check things
	if(check_game_end()):
		return
	else:
		time_loop()

func check_game_end():
	# TODO make this actually check things
	var player: CasterFrameBase = $Playspace/PlayerSlot.cards[0]
	var opponent: CasterFrameBase = $Playspace/OpponentSlot.cards[0]
	if(player.card_data.current_health <= 0):
		SignalBus.emit_signal("run_loss")
	return false

# For testing purposes
func print_status():
	if Globals.DEBUG == false:
		return
	var output: String = "Start Debug"
	output+="\nPhase: " + phase
	output += "\nPlayerCastTime: " + str(spell_manager.player_cast_time)
	output += "\nOppCastTime: " + str(opponent_manager.cast_time)
	if(Globals.DEBUG):
		if(phase == "player_decision"):
			output += "\nWaiting on Player"
	output += "\nEnd Debug"
	print(output)
