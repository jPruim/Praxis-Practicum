extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_new_game_btm_pressed() -> void:
	$"../RunManager".new_game()
	pass # Replace with function body.


func _on_resume_btn_pressed() -> void:
	$"../RunManager".resume()
	pass # Replace with function body.


func _on_settings_btn_pressed() -> void:
	pass # Replace with function body.
