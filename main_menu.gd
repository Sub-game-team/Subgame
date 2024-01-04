extends Node

@export var room_1_1: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	var current_room = room_1_1.instantiate()
	add_child(current_room)
	queue_free()
