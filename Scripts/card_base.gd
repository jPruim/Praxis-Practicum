extends Node2D

# Signals
signal hovered
signal hovered_off

# Properties
var hand_position: Vector2
var card_database

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	card_database = preload("res://Scripts/CardDatabase.gd")
	get_parent().connect_card_signals(self)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	pass


func _on_area_2d_mouse_entered() -> void:
	emit_signal("hovered", self)
	pass # Replace with function body.


func _on_area_2d_mouse_exited() -> void:
	emit_signal("hovered_off", self)
	pass # Replace with function body.

# Set Card from Array
# Order (database ENUM) { DISPLAY_NAME, CARD_TYPE, CAST_TIME, SUMMON_ATTACK, SUMMON_HEALTH, DIRECT_DAMAGE, DAMAGE_TYPE, DIRECT_BLOCK, CARD_TEXT, ANIMATION }
func set_all(array):
	card_database = preload("res://Scripts/CardDatabase.gd") # No idea why this needs to be called here TODO: move ENUM to an autoload
	$Name.text = str(array[card_database.CARD_INFO.DISPLAY_NAME])
	$Attack.text = str(array[card_database.CARD_INFO.SUMMON_ATTACK])
	$Health.text = str(array[card_database.CARD_INFO.SUMMON_HEALTH])
	$Details.text = str(array[card_database.CARD_INFO.CARD_TEXT])
	$Cost.text = str(array[card_database.CARD_INFO.CAST_TIME])
	$Type.text = str(array[card_database.CARD_INFO.DISPLAY_NAME])
	$DirectDamage.text = str(array[card_database.CARD_INFO.DIRECT_DAMAGE])
	$DamageType.text = str(array[card_database.CARD_INFO.DAMAGE_TYPE])
	$DirectBlock.text = str(array[card_database.CARD_INFO.DIRECT_BLOCK])
	if array[card_database.CARD_INFO.DIRECT_BLOCK]:
		$Container/AnimatedSprite2D.animation = str(array[card_database.CARD_INFO.DIRECT_BLOCK])
	else:
		$Container/AnimatedSprite2D.animation = "FireSparks"
# Create Array from Card
func store_card():
	return [$Name.text, $Type.text, $Cost.text, $Attack.text, $Health.text, $DirectDamage.text, $DamageType.text, $DirectBlock.text, $Details.text, $Container/AnimatedSprite2D.animation]
