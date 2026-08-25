extends VBoxContainer


## Name of bus
@export var bus: String

## Displayed Label
@export var labelText: String

## Reference to the bus
var bus_index: int
## slider node
@onready var slider: Slider = $"Slider"
@onready var label: Label = $"Label"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	slider.value_changed.connect(_on_value_changed)
	initialize_values()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
## Handle slider changing
func _on_value_changed(val: float):
	## TODO: Remove this comment
	#print(labelText, ": ", str(linear_to_db(val)))	
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(val))

func initialize_values():
	bus_index = AudioServer.get_bus_index(bus)
	slider.value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))
	label.text = labelText
