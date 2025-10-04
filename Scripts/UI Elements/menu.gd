extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.connect("menu_button_pressed", _on_menu_button_pressed)
	display_menu()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_menu_button_pressed() -> void:
	display_menu()

func _on_new_game_btm_pressed() -> void:
	SignalBus.emit_signal("run_start")
	hide_all()
	pass # Replace with function body.


func _on_resume_btn_pressed() -> void:
	SignalBus.emit_signal("run_resume")
	hide_all()
	pass # Replace with function body.


func _on_settings_btn_pressed() -> void:
	display_settings()
	pass # Replace with function body.

func display_settings():
	$MenuContainer/MainMenu.visible = false
	$MenuContainer/Settings.visible = true
	$MenuContainer/Book.visible = true
	$MenuContainer/MainMenu/MenuButtons.mouse_filter = 2 # IGNORE
	$MenuContainer/Settings/MenuButtons.mouse_filter = 0 # STOP

func display_menu():
	$MenuContainer/MainMenu.visible = true
	$MenuContainer/Settings.visible = false
	$MenuContainer/Book.visible = true
	$MenuContainer/MainMenu/MenuButtons.mouse_filter = 0 # STOP
	$MenuContainer/Settings/MenuButtons.mouse_filter = 2 # IGNORE

func hide_all():
	$MenuContainer/MainMenu.visible = false
	$MenuContainer/Settings.visible = false
	$MenuContainer/Book.visible = false
	$MenuContainer/MainMenu/MenuButtons.mouse_filter = 2 # IGNORE
	$MenuContainer/Settings/MenuButtons.mouse_filter = 2 # IGNORE

func _on_back_pressed() -> void:
	display_menu()
	pass # Replace with function body.


func _on_quit_btn_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.
