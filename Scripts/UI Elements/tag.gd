class_name Tag
extends MarginContainer


var tag_data = {
	"Default": "Empty Tag",
	"Fire": "Removes Ice, does double dmg to enemies with Fire",
	"Ice": "Removes Fire, does double dmg to enemies with Ice",
	"Strength": "Increase dmg by 1",
	"Repeated": "Casts or attacks an additional time",
	"Unstackable": "Summon cannot stack",
	"Barrier": "Blocks dmg, Decays if not used",
	"Delayed": "Adds 1 cast time",
	"Summon": "Attacks each turn",
}
var displaying: String = ""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$".".z_index = Globals.Z_INDEX.tag
	#set_tag_data("Default")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func set_tag_data(tag_name: String):
	displaying = tag_name
	$VBoxContainer/MarginHeader/MarginContainer/Header.text = displaying
	if tag_data.has(tag_name):
		$VBoxContainer/MarginBody/MarginContainer/Label.text = tag_data[tag_name]
	else:
		$VBoxContainer/MarginBody/MarginContainer/Label.text = tag_data["Default"]
	
