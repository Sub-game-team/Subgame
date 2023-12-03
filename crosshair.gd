extends Node2D

var crosshair = load("res://Art/Crosshair.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	var crosshair_size = crosshair.get_size()
	var offset = crosshair_size / 2
	Input.set_custom_mouse_cursor(crosshair,Input.CURSOR_ARROW,offset)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass     
