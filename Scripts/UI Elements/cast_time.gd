extends Node2D

var current_time
var ai = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_time(0)
	$".".z_index = Globals.Z_INDEX.cast_time
	$".".z_as_relative = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func set_time( time: int ):
	current_time = time
	if time >= 3:
		$Hourglass3.visible = true
		$Hourglass2.visible = false
		$Hourglass1.visible = false
		$Hourglass0.visible = false
	elif time == 2:
		$Hourglass3.visible = false
		$Hourglass2.visible = true
		$Hourglass1.visible = false
		$Hourglass0.visible = false
	elif time == 1:
		$Hourglass3.visible = false
		$Hourglass2.visible = false
		$Hourglass1.visible = true
		$Hourglass0.visible = false
	else:
		$Hourglass3.visible = false
		$Hourglass2.visible = false
		$Hourglass1.visible = false
		$Hourglass0.visible = false
	update_display()

func decrement_time():
	current_time -= 1
	if current_time < 0:
		current_time = 0
	update_display()

func update_display():
	if current_time == 0:
		$Time.visible = false
	else:
		$Time.visible = true
		$Time.text = str(current_time)
		
func get_time() -> int:
	return current_time
