class_name TagList
extends Control


const TAG_SCENE_PATH = "res://Scenes/UI/tag.tscn"

var tag_scene = preload(TAG_SCENE_PATH)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func set_taglist(tag_array: Array[String]):
	for label in tag_array:
		var tag: Tag
		tag = tag_scene.instantiate()
		tag.set_tag_data(label)
		$".".add_child(tag)
