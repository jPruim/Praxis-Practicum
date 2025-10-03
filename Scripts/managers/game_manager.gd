class_name GameManager
extends Node2D

var run_data: RunData
var save_file: String = "user://savefile.tres"
var achievement_file: String
var default_save_file: String = "res://Resources/GameData/default_game.tres"
var battle_manager: BattleManager
var battle_manager_scene = preload("res://Scenes/Playspace/battle_manager.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect_signals()
	hide_game_ui()
	$Menu.display_menu()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func connect_signals() -> void:
	SignalBus.connect("run_start", run_start)
	SignalBus.connect("run_resume", run_resume)
	SignalBus.connect("run_loss",	end_run)
	SignalBus.connect("run_won", end_run)

func run_resume():
	run_start(true) # TODO: make a resume function that doesn't bug

func run_start(resuming: bool = false):
	if( !resuming ):
		if(run_data):
			$Menu.hide()
		else:
			load_default_game_data()
			first_assignment()
	else:
		load_game_data()
		first_assignment()

func load_game_data():
	if ResourceLoader.exists(save_file):
		run_data =  load(save_file)
		print(run_data)
		get_tree().quit()
	else:
		run_data = load_default_game_data()
		save_game()
	return null

func save_game():
	ResourceSaver.save(run_data, save_file)

func load_default_game_data():
	if ResourceLoader.exists(default_save_file):
		run_data = load(default_save_file)
		return
	printerr("Loading null game data")
	get_tree().quit()

func end_run(victory: bool):
	if(victory):
		print("Victory")
		pass
	else:
		print("Defeat")
	
func next_phase():
	if run_data.phase == "assignment":
		run_data.phase = "post_fight_dialogue"
	elif run_data.phase == "post_fight_dialogue":
		if (run_data.assignment == 12):
			run_data.phase = "victory"
			SignalBus.emit_signal("run_win")
		run_data.phase = "shoppping"
	elif run_data.phase == "shopping":
		run_data.phase = "assignment"
	save_game()

func first_assignment():
	show_game_ui()
	run_data.assignment = 1
	battle_manager = battle_manager_scene.instantiate()
	$".".add_child(battle_manager)
	battle_manager.setup_combat(run_data)

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
	print("menu button pressed")
	$Menu.display_menu()
	pass # Replace with function body.
