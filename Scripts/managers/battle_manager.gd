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
var caster_frame_base_scene = preload("res://Scenes/Cards/caster_frame_base.tscn")
var player: CasterFrameBase
var enemy: CasterFrameBase
const DEFAULT_DELAY = 0.5
var phase_list = ["start_turn","ai_decision", "player_decision","spell_cast", "clean_up", "end_step"]
var phase: String
var iterations: int = 50 # TODO remove this, infinite loop catcher

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
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass

func set_player_turn(state: bool):
	SignalBus.emit_signal("player_turn", state)

func _player_turn_changed(state: bool):
	is_player_turn = state

func setup_combat(run_data: RunData):
	#DataManager.print_run_data(run_data)
	identify_slots()
	in_combat = true
	setup_player(run_data)
	var enemy_type = run_data.assignment_list[run_data.assignment - 1]
	var enemy_data = DataManager.load_enemy_game_data(enemy_type)
	setup_enemy(enemy_data)
	$CardManager.initialize_decks(run_data)
	phase = "start_turn"
	time_loop()

func setup_player(run_data: RunData):
	player = caster_frame_base_scene.instantiate()
	player.set_aloction()
	player.set_default_data()
	player.z_index = Globals.Z_INDEX["caster_frame"]
	player.scale = Globals.SCALE.caster
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
	enemy.scale = Globals.SCALE.caster
	enemy.set_display_name(enemy_data.name)
	enemy.set_animation("Adventurer")
	enemy.position = Globals.ENEMY_POSITION
	enemy.set_health(enemy_data.current_health)
	enemy.in_slot = true
	$"Playspace/OpponentSlot".cards.append(enemy)
	enemy.animation_reveal()
	$".".add_child(enemy)

func _on_pass_button_pressed() -> void:
	set_player_turn(false)
	next_phase()
	time_loop()

# Game Phase Setup
func next_phase():
	if(in_combat):
		phase = phase_list[(1 + phase_list.find(phase)) % phase_list.size()]

func time_loop():
	if (iterations <= 0 || in_combat == false):
		return
	else:
		iterations-=1
	print_status()
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
			return 
		next_phase()
	elif(phase == "spell_cast"):
		increment_time() # Spell resolution
		next_phase()
	elif(phase == "clean_up"):
		clean_up()
		next_phase()
	elif(phase == "end_step"):
		end_step()
		next_phase()
	# Always keep cast times up to date
	update_cast_times()
	time_loop_delay()


# Any end step effects
func end_step():
	pass



		
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
	update_cast_times()
	spell_manager.resolve_spells()

	
# Hold the beginning of the time increment setup
func start_turn():
	# Handle Player Start turn
	$"CardManager/".get_node("PlayerDeck").draw_card()
	$"CardManager/PlayerHand".update_hand_positions()
	
	# Handle AI Start turn
	$"OpponentManager".start_turn()
	
	find_empty_slots()
	find_full_slots()

@warning_ignore("unused_parameter")
func play_card(card, caster = "player", cast_time_mod = 0, cast_damage_mod = 0):
	pass

func _on_opponent_targeting_player(card: CardBase):
	print("AI casting at Player")
	card.being_cast = true
	create_target(Globals.PLAYER_POSITION, false)
	spell_manager.cast(card, false)
	

func _on_opponent_targeting_self(card: CardBase):
	print("AI casting at self")
	card.being_cast = true
	create_target(Globals.ENEMY_POSITION, false)
	spell_manager.cast(card, false)
	
func _on_opponent_targeting_slot(slot: CardSlot, card: CardBase):
	print("AI casting at slot")
	if(!slot):
		printerr("AI Casting at empty slot")
	card.being_cast = true
	create_target(slot.position, false)
	spell_manager.cast(card, false)


func _on_player_targeting_opponent(card: CardBase):
	SignalBus.emit_signal("player_turn", false)
	card.being_cast = true
	create_target(Globals.ENEMY_POSITION, true)
	spell_manager.cast(card, true)
	$Playspace/PlayerCastTime.set_time(player_cast_time)
	is_player_turn = false
	next_phase()
	time_loop_delay(2)


func _on_player_targeting_self(card: CardBase):
	SignalBus.emit_signal("player_turn", false)
	card.being_cast = true
	create_target(Globals.PLAYER_POSITION, true)
	spell_manager.cast(card, true)
	$Playspace/PlayerCastTime.set_time(player_cast_time)
	is_player_turn = false
	next_phase()
	time_loop_delay(2)
	
func _on_player_targeting_slot(slot: CardSlot, card: CardBase):
	SignalBus.emit_signal("player_turn", false)
	card.being_cast = true
	create_target(slot.position, true)
	spell_manager.cast(card, true)
	$Playspace/PlayerCastTime.set_time(player_cast_time)
	is_player_turn = false
	next_phase()
	time_loop_delay(2)

@warning_ignore("unused_parameter")
func time_loop_delay(amount = DEFAULT_DELAY):
	await get_tree().create_timer(amount).timeout
	time_loop()
	return

# Theoretically only needs to be called once, 
func identify_slots():
	for i in $"Playspace".get_children():
		if i is CardSlot:
			if !i.player_owned && !i.is_opponent:
				ai_slots.append(i)
			elif i.player_owned && !i.is_player:
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
	var current_target: Target = target_scene.instantiate()
	current_target.position = location
	if (player_owned):
		current_target.display_player_target()
		current_player_targets.append(current_target)
	else:
		current_target.display_enemy_target()
		current_opponent_targets.append(current_target)
	$".".add_child(current_target)
	
	return

func clear_target(player_owned):
	if player_owned:
		for x in current_player_targets:
			x.free()
		current_player_targets = []
	else:
		for y in current_opponent_targets:
			y.free()
		current_opponent_targets = []
	return

func clean_up():
	check_game_end()
	# Clean up targets
	if player_cast_time == 0:
		clear_target(true)
	if opponent_manager.cast_time == 0:
		clear_target(false)
	for slot: CardSlot in ai_slots:
		if slot.cards.size() > 0 && slot.cards[0].get_health() <=0:
			slot.cards[0].queue_free()
			slot.cards = []
		slot.update_graphic()
	for slot: CardSlot in player_slots:
		if slot.cards.size() > 0 && slot.cards[0].get_health() <= 0:
			slot.cards[0].queue_free()
			slot.cards = []
		slot.update_graphic()
	$Playspace/PlayerSlot.update_graphic()
	$Playspace/OpponentSlot.update_graphic()
	
func check_game_end():
	if(player.get_card_info().summon_health <= 0):
		print("Player Health: ", player.get_card_info().summon_health)
		SignalBus.emit_signal("fight_loss")
		in_combat = false
	elif(enemy.get_card_info().summon_health <= 0):
		SignalBus.emit_signal("fight_won")
		in_combat = false
	

# For testing purposes
func print_status():
	if Globals.DEBUG == false:
		return
	var output = ""
	output+="\nPhase: " + phase
	output += "\n\tPlayerCastTime: " + str(spell_manager.player_cast_time)
	output += "\n\tOppCastTime: " + str(opponent_manager.cast_time)
	output += "\n\tHealth: " + str(player.get_card_info().summon_health)
	if(Globals.DEBUG):
		if(phase == "player_decision"):
			output += "\n\tWaiting on Player"
	print(output)

func update_cast_times():
	$Playspace/PlayerCastTime.set_time(player_cast_time)
	$Playspace/OpponentCastTime.set_time($OpponentManager.cast_time)
