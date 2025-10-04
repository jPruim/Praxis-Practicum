class_name CasterFrameBase
extends CardBase

var alocation_set: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CardFront/Cost.visible = false
	$CardFront/Type.visible = false
	$CardFront/Attack.visible = false
	$CardFront/Details.visible = false
	$CardFront/Container.size.y = 250
	$".".z_index = Globals.Z_INDEX.caster_frame
	pass # Replace with function body.

func set_aloction():
	if( !alocation_set ):
		$CardFront/Container/AnimatedSprite2D.position.y += 30
		$CardFront/Container/Sprite2D.position.y += 30	
	alocation_set = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
