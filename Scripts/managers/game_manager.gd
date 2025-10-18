class_name GameManager
extends Node2D

var run_data: RunData
var battle_manager: BattleManager
var battle_manager_scene = preload("res://Scenes/Playspace/battle_manager.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect_signals()
	hide_game_ui()
	$Menu.display_menu()
	pass # Replace with function body.




# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass
	
func connect_signals() -> void:
	SignalBus.connect("run_start", run_start)
	SignalBus.connect("run_resume", run_resume)
	SignalBus.connect("run_loss",	end_run)
	SignalBus.connect("run_won", end_run)
	SignalBus.connect("fight_enter", initialize_fight)
	SignalBus.connect("shop_enter", initialize_shop)
	SignalBus.connect("shop_exit", end_shop)
	SignalBus.connect("fight_loss", fight_loss)
	SignalBus.connect("fight_won", fight_won)


func initialize_fight():
	show_game_ui()
	battle_manager = battle_manager_scene.instantiate()
	$".".add_child(battle_manager)
	battle_manager.setup_combat(run_data)
	pass

func initialize_shop():
	pass

func fight_loss():
	print("Fight Loss")
	fight_cleanup()
	end_run(false)
	pass

func fight_won():
	print("Fight Won", run_data)
	run_data.gold += run_data.max_health - run_data.current_health
	fight_cleanup()
	next_phase()
	
func fight_cleanup():
	battle_manager.queue_free()

func end_shop():
	next_phase()

func run_resume():
	run_start(true) 

func run_start(resuming: bool = false):
	$Menu.hide_all()
	$Fog/Fog.visible = false
	if( !resuming ):
		# Remove previous game from active scene
		if(!(!(battle_manager))):
			battle_manager.queue_free()
		run_data = DataManager.load_default_game_data()
		first_assignment()
	else:
		if(run_data):
			return
		run_data = DataManager.load_game_data()
		first_assignment()



func end_run(victory: bool):
	if(victory):
		print("Victory")
		pass
	else:
		print("Defeat")
	
func next_phase():
	if run_data.phase == "assignment":
		run_data.phase = "post_fight_dialogue"
		# TODO: Add dialogue
		next_phase()
	elif run_data.phase == "post_fight_dialogue":
		if (run_data.assignment == 12):
			run_data.phase = "victory"
			SignalBus.emit_signal("run_win")
		run_data.phase = "shoppping"
		SignalBus.emit_signal("shop_enter")
	elif run_data.phase == "shopping":
		run_data.phase = "assignment"
		run_data.assignment += 1
		SignalBus.emit_signal("fight_enter")
	DataManager.save_game(run_data)

func first_assignment():
	run_data.phase = "assignment"
	run_data.assignment = 1
	SignalBus.emit_signal("fight_enter")
	
func hide_game_ui():
	$UI.visible = false

func show_game_ui():
	$UI.visible = true

func update_money(difference: int):
	if run_data.gold - difference >= 0:
		run_data.gold += difference
	else:
		print("Attempted to buy in debt")
	$UI/HeaderBar/NinePatchRect/HBoxContainer/MoneyDisplay/Money.text = str(run_data.gold)
	
func update_assignment(difference: int):
	if difference >= 0:
		run_data.assignment += difference
	else:
		print("Assignment decrermented")
	$UI/HeaderBar/NinePatchRect/HBoxContainer/AssignmentDisplay/Assignment.text = str(run_data.assigment)

func update_ascension(difference: int):
	if difference >= 0:
		run_data.ascension += difference
	else:
		print("Assignment decrermented")
	$UI/HeaderBar/NinePatchRect/HBoxContainer/AssignmentDisplay/Assignment.text = str(run_data.ascension)

func _on_menubutton_pressed() -> void:
	$Menu.display_menu()
	$Fog/Fog.visible = true
	pass # Replace with function body.
