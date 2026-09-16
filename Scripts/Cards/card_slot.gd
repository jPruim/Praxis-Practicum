extends Node2D

class_name CardSlot



# Properties
var cards: Array[CardBase] = []
var max_cards = 1
var player_owned = false # True if the owner is the player
var is_player = false # True if the card slot is representing the player
var is_opponent = false # True if the card slot is representing the opponent
## The location in the board. Player summons attack y -=1....		
var board_location: Vector2 = Vector2( -1, -1)
var slot_effects: SlotEffects = SlotEffects.new()
@onready var play_space: PlaySpace = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$".".scale = Globals.SCALE.card
	$".".z_index = Globals.Z_INDEX.card_in_slot - 1
	SignalBus.connect("scene_end", _on_scene_end)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass

func set_animation_position():
	$CardFront/Container/AnimatedSprite2D.position.y = 85
	
func get_card() -> CardBase:
	if(cards.size() > 0):
		return cards[0]
	else:
		return null

func update_graphic():
	if(player_owned && $"CardSlotImage"):
		$"CardSlotImage".texture = load("res://Assets/Cards/Card Borders etc/card-outline-blue.png")
	elif(player_owned == false && $"CardSlotImage"):
		$"CardSlotImage".texture = load("res://Assets/Cards/Card Borders etc/card-outline-grey.png")
	update_slot_effects()
	if(cards.size() == 0):
		return
	cards[0].position = $".".position
	cards[0].update_graphics_inslot()

func animate_dmg(A_SPEED = Globals.DEFAULT_ASPEED):
	var tween = get_tree().create_tween()
	tween.tween_property($".", "modulate", Color.RED, A_SPEED)
	get_card().update_graphics()
	tween.tween_property($".", "modulate", Color.WHITE, A_SPEED)
	#tween.tween_callback($".".queue_free)
	
## Dmg equation for a cardslot that does dmg to its summon	
func take_dmg(dmg: Damage, overflow = false, A_SPEED = Globals.DEFAULT_ASPEED) -> Damage:
	# Handle empty card slots without overflow
	if !has_summon() && !overflow:
		dmg.set_dmg(0)
		return dmg
	# Handle empty slots with overflow
	elif !has_summon() && overflow:
		return dmg
	# TODO: Make sure that somewhere else is accepting overflow
	# Handle "mult" bonuses
	dmg.set_dmg(floor(dmg.dmg * RelicManager.get_spell_power_mult()))
	if dmg.dmg_type == "FIRE" && get_card().has_effect("ICE"):
		@warning_ignore("narrowing_conversion")
		dmg.set_dmg(dmg.dmg * RelicManager.get_melt_mult())
	elif dmg.dmg_type == "ICE" && get_card().has_effect("FIRE"):
		@warning_ignore("narrowing_conversion")
		dmg.set_dmg(dmg.dmg * RelicManager.get_melt_mult())
		
	# Check for Overflow and resolve dmg
	if overflow && dmg.dmg > get_card().get_health():
		dmg.set_dmg(dmg.dmg - get_card().get_health())
		get_card().set_health(0)
	else:
		get_card().adjust_health(-1 * dmg.dmg)
		dmg.set_dmg(0)
	animate_dmg(A_SPEED)
	return dmg
	
## Text output for debug testing of a CardSlot
func get_debug_output():
	var card: CardBase = get_card()
	if !card:
		return "Empty "
	var output: String = ""
	output += card.get_card_name()
	output += "("
	output += str(cards.size())
	output += "): "
	output += str(card.get_health())
	output += "hp."
	return output

## Empty cards and redo graphics
func clear():
	# TODO: Check that 
	slot_effects.reset_values()
	cards = []
	update_graphic()
	
## If this card slot has a summon
func has_summon() -> bool:
	if cards.size() > 0:
		return true
	else:
		return false

func calc_opposing_summon_location() -> Vector2:
	var new_y
	if board_location.y == 0:
		new_y = 1
	else:
		new_y = 0
	return Vector2(board_location.x, new_y)
	
## return opposing (positionally) slot
func get_opposing_slot():
	var slot = play_space.get_slot(calc_opposing_summon_location())
	if slot != null:
		return slot
	else:
		printerr("No opposing slot")
		return null
		
## Destroy cards on specific scene ends
func _on_scene_end(scene: String):
	if(scene == "fight" || scene == "shop"):
		for card in cards:
			card.delete_me = true
			card.check_clean_up()

## Update slot effects
func update_slot_effects():
	## TODO: Add full slot effect functionality
	pass
