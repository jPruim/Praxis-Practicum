extends Node2D

# Properties
var hand_position: Vector2
var card_database
var in_slot = false # Boolean for being in the card_slot
var ai_card = false
var card_info
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	card_database = preload("res://Scripts/CardDatabase.gd")
	get_parent().connect_card_signals(self)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	pass


func _on_area_2d_mouse_entered() -> void:
	SignalBus.emit_signal("hovered", self)
	pass # Replace with function body.


func _on_area_2d_mouse_exited() -> void:
	SignalBus.emit_signal("hovered_off", self)
	pass # Replace with function body.


# Set Card from Array
# Order (database ENUM) { DISPLAY_NAME, CARD_TYPE, CAST_TIME, SUMMON_ATTACK, SUMMON_HEALTH, DIRECT_DAMAGE, DAMAGE_TYPE, DIRECT_BLOCK, CARD_TEXT, ANIMATION }
func set_all(array):
	card_info = array

# Set Card from Array
# Order (database ENUM) { DISPLAY_NAME, CARD_TYPE, CAST_TIME, SUMMON_ATTACK, SUMMON_HEALTH, DIRECT_DAMAGE, DAMAGE_TYPE, DIRECT_BLOCK, CARD_TEXT, ANIMATION }
func set_display(array):
	card_database = preload("res://Scripts/CardDatabase.gd") # No idea why this needs to be called here TODO: move ENUM to an autoload
	$CardFront/Name.text = str(array[card_database.CARD_INFO.DISPLAY_NAME])
	$CardFront/Attack.text = str(array[card_database.CARD_INFO.SUMMON_ATTACK])
	$CardFront/Health.text = str(array[card_database.CARD_INFO.SUMMON_HEALTH])
	$CardFront/Details.text = str(array[card_database.CARD_INFO.CARD_TEXT])
	$CardFront/Cost.text = str(array[card_database.CARD_INFO.CAST_TIME])
	$CardFront/Type.text = str(array[card_database.CARD_INFO.DISPLAY_NAME])
	$CardFront/DirectDamage.text = str(array[card_database.CARD_INFO.DIRECT_DAMAGE])
	$CardFront/DamageType.text = str(array[card_database.CARD_INFO.DAMAGE_TYPE])
	$CardFront/DirectBlock.text = str(array[card_database.CARD_INFO.DIRECT_BLOCK])
	
	# Handle Animations not being added yet ( So I can add them over time)
	if array[card_database.CARD_INFO.ANIMATION]:
		$CardFront/Container/AnimatedSprite2D.animation = str(array[card_database.CARD_INFO.ANIMATION])
	else:
		$CardFront/Container/AnimatedSprite2D.animation = "FireSparks" # TODO: make an empty spriteframe at some point
	
# Create Array from Card
func get_card_info():
	return card_info

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
