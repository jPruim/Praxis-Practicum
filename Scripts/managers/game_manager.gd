extends Node2D

var runData: RunData
var saveFile: String
var achievementFile: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect_signals()
	$Menu.display_menu()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func connect_signals() -> void:
	SignalBus.connect("run_start", start_run(false))
	SignalBus.connect("run_resume", start_run(true))
	SignalBus.connect("run_loss", end_run(false))
	SignalBus.connect("run_won", end_run(true))


func start_run(resuming: bool):
	if( !resuming ):
		runData = 


func load_game_data():
	if ResourceLoader.exists(save_path):
		return load(save_path)
	printerr("Loading null game data")
	return null

func save_game_data():
	ResourceSaver.save(runData, saveFile)
