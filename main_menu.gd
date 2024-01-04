extends Node

@export var room_1_1: PackedScene
@export var reset_settings: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	var current_room = room_1_1.instantiate()
	add_child(current_room)
	$Node2D.queue_free()
	$Node2D2.queue_free()
	$Camera2D.queue_free()
	
