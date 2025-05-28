extends Node2D


# Constants
const THOUGHT_DELAY = 0.7

# Propterties
var timer
var 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer = $OpponentTimer
	timer.one_shot = true

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Any automatic "start of turn" affects
func start_turn():
	$"../CardManager".get_node("OpponentDeck").draw_card()


# Time function
func decision_delay(delay = THOUGHT_DELAY):
	timer.wait_time = delay
	timer.start()
	await timer.timeout
	return
