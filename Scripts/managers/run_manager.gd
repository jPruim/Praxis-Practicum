class_name RunManager
extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect_signals()
	pass # Replace with function body.


func connect_signals():
	SignalBus.connect("run_start", _on_run_start())
	SignalBus.connect("run_resume", _on_run_resume())
	SignalBus.connect("run_loss", _on_run_loss())
	SignalBus.connect("run_win", _on_run_win())
	SignalBus.connect("shop_enter", _on_shop_enter())
	SignalBus.connect("shop_exit", _on_shop_exit())
	SignalBus.connect("fight_loss", _on_fight_loss())
	SignalBus.connect("fight_won", _on_fight_won())
	
# Resume Last Game
func resume():
	# TODO: Add resume Functionality
	pass

# Start a new Game
func new_game():
	pass

func _on_run_start():
	var battleManager : BattleManager = BattleManager.instantiate()
	pass

func _on_run_resume():
	var battleManager : BattleManager = BattleManager.instantiate()
	pass
	
func _on_run_loss():
	var battleManager : BattleManager = BattleManager.instantiate()
	pass
	
func _on_run_win():
	var battleManager : BattleManager = BattleManager.instantiate()
	pass

func _on_shop_enter():
	var battleManager : BattleManager = BattleManager.instantiate()
	pass

func _on_shop_exit():
	var battleManager : BattleManager = BattleManager.instantiate()
	pass
	
func _on_fight_won():
	var battleManager : BattleManager = BattleManager.instantiate()
	pass
	
func _on_fight_loss():
	var battleManager : BattleManager = BattleManager.instantiate()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
