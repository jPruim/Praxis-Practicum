extends Sprite2D

## how much of the light range can flicker
@export_range(0.0, 1.0, .01) var flicker_variance: float = 0.9
@export_range(0.01,3.0, 0.01) var flicker_speed: float = 1.0
@export_range(0.5,10.0, 0.1) var max_brightness: float = 4.0
var brightening: bool = true
## between 0 and 1
var fraction: float = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	## Set candle direction randomly
	brightening = bool(floor(randf()))
	fraction = randf_range(1-flicker_variance, 1)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	automatic_brightness(delta)
	pass

## Automatic updating of brightness
func automatic_brightness(delta: float):
	# If near dimmest setting set brightening to true
	if fraction < 1 - flicker_variance:
		fraction = 1 - flicker_variance
		brightening = true
	elif fraction > 1:
		fraction = 1
		brightening = false
	else:
		fraction += flicker_speed * delta *(2 * int(brightening) - 1)
	$Candlelight.energy = max_brightness * fraction
