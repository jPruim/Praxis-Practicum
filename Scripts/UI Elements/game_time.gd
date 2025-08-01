extends Node2D

var current_time

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_time( time: int ):
	if time == 3:
		$Hourglass3.visible = true
		$Hourglass2.visible = false
		$Hourglass1.visible = false
		$Hourglass0.visible = false
		current_time = 3
	elif time == 2:
		$Hourglass3.visible = false
		$Hourglass2.visible = true
		$Hourglass1.visible = false
		$Hourglass0.visible = false
		current_time = 2
	elif time == 1:
		$Hourglass3.visible = false
		$Hourglass2.visible = false
		$Hourglass1.visible = true
		$Hourglass0.visible = false
		current_time = 1
	else:
		$Hourglass3.visible = false
		$Hourglass2.visible = false
		$Hourglass1.visible = false
		$Hourglass0.visible = true
		current_time = 0
	update_display()

func decrement_time():
	current_time -= 1
	if current_time < 0:
		current_time = 0
	update_display()

func update_display():
	$Time.text = str(current_time)
		
func get_time() -> int:
	return current_time
