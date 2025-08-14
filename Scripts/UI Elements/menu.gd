extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide_all()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_new_game_btm_pressed() -> void:
	SignalBus.emit_signal("run_start")
	pass # Replace with function body.


func _on_resume_btn_pressed() -> void:
	SignalBus.emit_signal("run_resume")
	pass # Replace with function body.


func _on_settings_btn_pressed() -> void:
	display_settings()
	pass # Replace with function body.

func display_settings():
	$MainMenu.visible = false
	$Settings.visible = true
	$Book.visible = true

func display_menu():
	$MainMenu.visible = true
	$Settings.visible = false
	$Book.visible = true

func hide_all():
	$MainMenu.visible = false
	$Settings.visible = false
	$Book.visible = false

func _on_back_pressed() -> void:
	display_menu()
	pass # Replace with function body.
