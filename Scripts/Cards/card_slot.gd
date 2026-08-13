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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$".".scale = Globals.SCALE.card
	$".".z_index = Globals.Z_INDEX.card_in_slot - 1
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

	if(cards.size() == 0):
		return
	cards[0].position = $".".position
	cards[0].update_graphics_inslot()

func animate_dmg(A_SPEED = Globals.DEFAULT_ASPEED):
	var tween = get_tree().create_tween()
	tween.tween_property($".", "modulate", Color.RED, A_SPEED)
	tween.tween_property($".", "modulate", Color.WHITE, A_SPEED)
	#tween.tween_callback($".".queue_free)
	
	
## Text output for debug testing of a CardSlot
func get_debug_output():
	var card: CardBase = get_card()
	if !card:
		return "Empty "
	else:
		card.print_debug()
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
	cards = []
