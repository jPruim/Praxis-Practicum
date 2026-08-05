class_name CardDisplay
extends MarginContainer


const CARD_SCENE_PATH = "res://Scenes/Cards/card_base.tscn"
@export var card: CardBase

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.connect("scale_change_card", change_size)
	change_size()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func change_size(scale_factor: int = 2):
	var custom_margins = 15
	$PanelContainer.custom_minimum_size = scale_factor*Vector2(32,48)+ custom_margins*Vector2(1,1)

func set_card(acard:CardBase):
	if(!is_instance_valid($PanelContainer/CardBase)):
		var new_card: CardBase = preload(CARD_SCENE_PATH).instantiate()
		$PanelContainer.add_child(new_card)
	# import card data
	$PanelContainer/CardBase.copy(acard)
	# remove "hand" traits
	$PanelContainer/CardBase.draggable = false
	$PanelContainer/CardBase.ai_card = true
	$PanelContainer/CardBase.hand_position = Vector2(0,0)
	$PanelContainer/CardBase.in_slot = true
	recenter_card()


## put card to center of panel container
func recenter_card():
	$PanelContainer/CardBase.global_position = $PanelContainer.global_position
	
