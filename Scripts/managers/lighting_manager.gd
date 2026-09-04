extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect_signals()
	$PassLight.position = Globals.PASS_BUTTON_POSITION + Vector2(30,15)
	$BoardLight.position = Globals.VIEWPORT_SIZE/2
	initial_lighting()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass


func initial_lighting():
	reset_lights()
	menu_lighting(true)
	
func connect_signals():
	SignalBus.connect("menu_button_pressed", func(): menu_lighting(true))
	SignalBus.connect("menu_close", func(): menu_lighting(false))
	SignalBus.connect("fight_enter", battle_lighting)
	SignalBus.connect("shop_enter", shop_lighting)
	SignalBus.connect("player_turn", _pass_lighting)

func menu_lighting(val: bool):
	$MenuAmbient.visible = val
	
	
func _pass_lighting(state: bool = false):
	$PassLight.visible = state

func battle_lighting():
	reset_lights()
	$PlayerLight.visible = true
	$EnemyLight.visible = true
	$CardAmbient.visible = true
	$BoardLight.visible = true

	
func shop_lighting():
	reset_lights()
	$ShopLight.visible = true

func reset_lights():
	$PlayerLight.visible = false
	$EnemyLight.visible = false
	$Ambient.visible = true
	$CardAmbient.visible = true
	$ShopLight.visible = false
	$PassLight.visible = false
	$BoardLight.visible = false
	$MenuAmbient.visible = false
