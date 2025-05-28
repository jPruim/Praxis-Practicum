extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pass_button_pressed() -> void:
	opponent_turn()

func opponent_turn():
		# Make the button unclickable and invisible
	$"../PassButton".disabled = true
	$"../PassButton".visible = false
	# Initialize Opponent Turn
	$"../OpponentManager".start_turn()


func player_turn():
	$"../PassButton".visible = true
	$"../PassButton".disabled = false
