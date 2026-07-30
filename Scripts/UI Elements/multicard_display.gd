extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# a setup function for the display
func new_card_mdisplay(cards: Array[CardBase], preserve_order: bool = false):
	if preserve_order == false:
		cards.sort_custom(ordering)
	for x in cards:
		add_card_display(x)


# Function that determines a default order to hide deck order
static func ordering(a: CardBase, b: CardBase):
	# sort by casting cost
	if (a.card_data.cast_time < b.card_data.cast_time):
		return true
	elif a.card_data.cast_time > b.card_data.cast_time:
		return false
	# If cast times match then sort by name
	if (a.card_data.display_name < b.card_data.display_name):
		return true
	elif a.card_data.display_name > b.card_data.display_name:
		return false
	# then return false (possibly add more ordering later)
	return false

# function that adds 1 card to the display
func add_card_display(card: CardBase):
	var card_display: CardDisplay
	var card_display_scene = "res://Scenes/Cards/card_display.tscn"
	card_display = card_display_scene.instatiate()
	card_display.set_card(card)
	$VBoxContainer/GridContainer.add_child(card_display)
	return

# Close the display
func _on_close_button_pressed() -> void:
	$".".queue_free()
	pass # Replace with function body.
