class_name CardDisplay
extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.connect("scale_change_card", change_size)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func change_size(scale_factor: int = 2):
	$PanelContainer.custom_minimum_size = scale_factor*Vector2(32,48)

func set_card(card:CardBase):
	$PanelContainer/CardBase.copy(card)
