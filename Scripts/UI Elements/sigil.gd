class_name Sigil
extends Node2D

@export var blue_gem_location: Vector2 = Vector2(-15, -40)
@export var red_gem_location: Vector2 = Vector2(15, -40)
@export var coin_location: Vector2 = Vector2(-15, -20)
@export var count: int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func show_type(type: String):
	if("blue"):
		$BlueGem.visible = true
		$RedGem.visible = false
		$Coin.visible = false
		$".".position = blue_gem_location
		$Sigilbase.visible = true
		
	elif("red"):
		$BlueGem.visible = false
		$RedGem.visible = true
		$Coin.visible = false	
		$".".position = red_gem_location
		$Sigilbase.visible = true
		
	elif("coin"):
		$BlueGem.visible = false
		$RedGem.visible = false
		$Coin.visible = true	
		$".".position = coin_location
		$Sigilbase.visible = true

func hide_all():
		$BlueGem.visible = false
		$RedGem.visible = false
		$Coin.visible = false	
		$Sigilbase.visible = false

func update_count(diff: int): 
	count += diff
	$Count.text = str(count)
	# Hide count if count is less than 2 (i.e. count isn't needed)
	if(count <= 1):
		$Count.visible = false
	else:
		$Count.visible = true
