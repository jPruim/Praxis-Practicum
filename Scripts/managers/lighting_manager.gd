extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect_signals()
	initial_lighting()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass


func initial_lighting():
	$PlayerLight.visible = false
	$EnemyLight.visible = false
	$Ambient.visible = true
	$CardAmbient.visible = false
	$ShopLight.visible = false

func connect_signals():
	SignalBus.connect("menu_button_pressed", menu_lighting)
	SignalBus.connect("fight_enter", battle_lighting)
	SignalBus.connect("shop_enter", shop_lighting)
	

func menu_lighting():
	$PlayerLight.visible = false
	$EnemyLight.visible = false
	$Ambient.visible = true
	$CardAmbient.visible = true
	$ShopLight.visible = false
	
func battle_lighting():
	$PlayerLight.visible = true
	$EnemyLight.visible = true
	$Ambient.visible = true
	$CardAmbient.visible = true
	$ShopLight.visible = false
	
func shop_lighting():
	$PlayerLight.visible = false
	$EnemyLight.visible = false
	$Ambient.visible = true
	$CardAmbient.visible = false
	$ShopLight.visible = true
