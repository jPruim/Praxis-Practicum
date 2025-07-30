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
		current_time = 3
	elif time == 2:
		$Hourglass3.visible = false
		$Hourglass2.visible = true
		$Hourglass1.visible = false
		current_time = 2
	elif time == 1:
		$Hourglass3.visible = false
		$Hourglass2.visible = false
		$Hourglass1.visible = true
		current_time = 1
	else:
		$Hourglass1.visible = false
		$Hourglass1.visible = false
		$Hourglass1.visible = false
		
		
		
