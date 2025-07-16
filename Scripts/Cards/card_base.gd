class_name CardBase
extends Node2D

# Properties
var card_data:CardData = null
var hand_position: Vector2
var in_slot = false # Boolean for being in the card_slot
var ai_card = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().connect_card_signals(self)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	pass


func _on_area_2d_mouse_entered() -> void:
	SignalBus.emit_signal("card_hovered", self)
	pass # Replace with function body.


func _on_area_2d_mouse_exited() -> void:
	SignalBus.emit_signal("card_hovered_off", self)
	pass # Replace with function body.


# Set Card from a CardData object
func set_all(data: CardData):
	card_data = data

# Set Display and CardData from a CardData object
func set_display(data: CardData):
	$CardFront/Name.text = data.display_name
	$CardFront/Attack.text = str(data.summon_attack)
	$CardFront/Health.text = str(data.summon_health)
	$CardFront/Details.text = data.card_text
	$CardFront/Cost.text = str(data.cast_time)
	$CardFront/Type.text = data.card_type
	$CardFront/DirectDamage.text = str(data.direct_damage)
	$CardFront/DamageType.text = data.damage_type
	$CardFront/DirectBlock.text = str(data.direct_block)
	
	# Handle Animations not being added yet ( So I can add them over time)
	if data.animation != "":
		$CardFront/Container/AnimatedSprite2D.animation = data.animation
	else:
		$CardFront/Container/AnimatedSprite2D.animation = "FireSparks" # TODO: make an empty spriteframe at some point
	
# Create Array from Card
func get_card_info():
	return card_data

func get_card_type():
	return card_data.card_type

# Flip card to front from back
func animation_reveal():
	# Check if card back is visible
	if $CardFront.z_index < $CardBack.z_index:
		$AnimationPlayer.play("card_flip")

# Flip card to back	
func animation_conceal():
	# Check if Card front is visible
	if $CardFront.z_index > $CardBack.z_index:
		$AnimationPlayer.play_backwards("card_flip")
	
# Animate card to position
func animate_card_to_position(position, speed = Globals.DEFAULT_ASPEED):
	var tween = get_tree().create_tween()
	tween.tween_property($".", "position", position, speed)
	
# Animate card to Scale
func animate_card_to_scale(scale, speed = Globals.DEFAULT_ASPEED):
	var tween = get_tree().create_tween()
	tween.tween_property($".", "scale", scale, speed)


func animate_card_to_slot(position, scale = Globals.CARD_SCALE_PlACED, speed = Globals.DEFAULT_ASPEED):
	animate_card_to_position(position, speed)
	animate_card_to_scale(scale, speed)
