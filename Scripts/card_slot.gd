extends Node2D



# Constants
const SLOT_SCALE = Vector2(0.9, 0.9)

# Properties
var cards = []
var max_cards = 1



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$".".scale = SLOT_SCALE
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
