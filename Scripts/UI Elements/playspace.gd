extends Node2D

#load
const cardBase = preload("res://Scenes/Cards/card_base.tscn")
const cardSlot = preload("res://Scenes/Cards/card_slot.tscn")
var PlayerHand = preload("res://Scenes/Cards/player_hand.tscn")

# Dimensions of the Card Slots ( Horizontal, Vertical)
@export var boardDimensions = Vector2(3, 2)
@export var centerPoint : Vector2
@export var slotMargin = Vector2( 10, 2)
@export var slotSize = Vector2( 32, 48 )
# Called when the node enters the scene tree for the first time.


func _enter_tree() -> void:
	# Needs to happen before some of the ready() functions of children

	pass



func initialize_card_slots():
	var newSlot = cardSlot.instantiate() 
	var x_pos
	var y_pos
	# Calculate the initial position of the top left most cardSlot
	centerPoint = Globals.VIEWPORT_SIZE / 2
	# Shift the board up to skew for more player space
	centerPoint += Vector2(0, +4) 
	var x_pos_first = centerPoint.x - (0.5 * ((boardDimensions.x -1) * slotSize.x))
	var y_pos_first = centerPoint.y - (0.5 * ((boardDimensions.y -1) * slotSize.y))
	# Handle Margins
	x_pos_first -= 0.5 * (boardDimensions.x - 1) * slotMargin.x
	y_pos_first -= 0.5 * (boardDimensions.y - 1) * slotMargin.y
	
	# Generate and calculate positions for each card slot
	for i in range(0, boardDimensions.x):
		for j in range(0, boardDimensions.y):
			newSlot = cardSlot.instantiate()
			if (j >= boardDimensions.y / 2):
				newSlot.player_owned = true
			x_pos = x_pos_first + (i * (slotSize.x + slotMargin.x))
			y_pos = y_pos_first + (j * (slotSize.y + slotMargin.y))
			newSlot.position = Vector2(x_pos,y_pos)
			newSlot.visible = true
			newSlot.update_graphic()
			$".".add_child(newSlot)
	$Centerpoint.position = centerPoint
	

func _ready() -> void:
	initialize_card_slots()
	$OpponentSlot.is_opponent = true
	$OpponentSlot.player_owned = false
	$OpponentSlot.position = Globals.ENEMY_POSITION
	$PlayerSlot.is_player = true
	$PlayerSlot.player_owned = false
	$PlayerSlot.position = Globals.PLAYER_POSITION
	$PlayerCastTime.position = Globals.PLAYER_CAST_POSITION
	$OpponentCastTime.position = Globals.ENEMY_CAST_POSITION
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
