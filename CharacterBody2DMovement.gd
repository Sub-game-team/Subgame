extends CharacterBody2D

@export var speed = 0
var input_direction2
var yMovement = 0
var xMovement = 0

func get_input():
	if Input.is_action_pressed("left") and xMovement >= -498:
		xMovement -= 4
	if Input.is_action_pressed("right") and xMovement <= 498:
		xMovement += 4
	if Input.is_action_pressed("up") and yMovement >= -498:
		yMovement -= 4
	if Input.is_action_pressed("down") and yMovement <= 498:
		yMovement += 4
	if xMovement >= 1 and not Input.is_action_pressed("right"):
		xMovement -= 2
		print("test1")
	if xMovement <= 0 and not Input.is_action_pressed("left"):
		xMovement += 2
		print("test2")
	if yMovement >= 0 and not Input.is_action_pressed("up"):
		yMovement -= 2
		print("test3")
	if yMovement <= 0 and not Input.is_action_pressed("down"):
		yMovement += 2
		print("test4")
	velocity = Vector2(xMovement, yMovement)
	print(Input.is_action_pressed("left"))
	print(Input.is_action_pressed("right"))
	print(Input.is_action_pressed("up"))
	print(Input.is_action_pressed("down"))
	print(xMovement)
	print(yMovement)
	
func _physics_process(_delta):
	get_input()
	move_and_slide()
