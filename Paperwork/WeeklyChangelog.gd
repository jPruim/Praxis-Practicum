extends Node

## Array[Array[String]]
var changelog
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	changelog.appendweekone()
	print(changelog)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func appendweekone():
	var this_week = []
	this_week.append("CardBase: cleanup signals")
	
	
	changelog.append(this_week)
