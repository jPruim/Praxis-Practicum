class_name CasterFrameBase
extends CardBase


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CardFront/Cost.visible = false
	$CardFront/Type.visible = false
	$CardFront/Attack.visible = false
	$CardFront/Details.visible = false
	$CardFront/Container.size.y = 250
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
