class_name GameManager
extends Node2D

var run_data: RunData
var save_file: String = "user://savefile.tres"
var achievement_file: String
var default_save_file: String = "res://Resources/GameData/default_game.tres"
var battle_manager: BattleManager
var battle_manager_scene = "res://Scenes/Playspace/battle_manager.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect_signals()
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
	run_start(true)

func run_start(resuming: bool = false):
	if( !resuming ):
		run_data = load_default_game_data()
	else:
		run_data = load_game_data()
	first_assignment()

func load_game_data():
	if ResourceLoader.exists(save_file):
		return load(save_file)
	else:
		run_data = load_default_game_data()
		save_game_data()
	return null

func save_game_data():
	ResourceSaver.save(run_data, save_file)

func load_default_game_data():
	if ResourceLoader.exists(default_save_file):
		run_data = load(default_save_file)
		return
	printerr("Loading null game data")
	return

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

func first_assignment():
	run_data.assignment = 1
	battle_manager = battle_manager_scene.instantiate()
	battle_manager.setup_combat(run_data)
	$".".add_child(battle_manager)
