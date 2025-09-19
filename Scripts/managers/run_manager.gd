class_name RunManager
extends Node2D

var battleManager: BattleManager
var battleManager_scene = preload("res://Scenes/Playspace/battle_manager.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect_signals()
	pass # Replace with function body.


func connect_signals():
	SignalBus.connect("run_start", _on_run_start)
	SignalBus.connect("run_resume", _on_run_resume)
	SignalBus.connect("run_loss", _on_run_loss)
	SignalBus.connect("run_win", _on_run_win)
	SignalBus.connect("shop_enter", _on_shop_enter)
	SignalBus.connect("shop_exit", _on_shop_exit)
	SignalBus.connect("fight_loss", _on_fight_loss)
	SignalBus.connect("fight_won", _on_fight_won)
	
# Resume Last Game
func resume():
	# TODO: Add resume Functionality
	pass

# Start a new Game
func new_game():
	pass

func _on_run_start():
	pass

func _on_run_resume():
	pass
	
func _on_run_loss():
	pass
	
func _on_run_win():
	pass

func _on_shop_enter():
	pass

func _on_shop_exit():
	pass
	
func _on_fight_won():
	pass
	
func _on_fight_loss():
	pass

func setup_fight():
	battleManager = battleManager_scene.instantiate()
	$".".add_child(battleManager)
	SignalBus.emit_signal("fight_start")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
