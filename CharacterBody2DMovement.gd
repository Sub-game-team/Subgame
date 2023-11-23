extends CharacterBody2D

@export var speed = 0
var input_direction2
var yMovement = 0
var xMovement = 0

func get_input2():
	if Input.is_action_pressed("left") and xMovement <= 498:
		xMovement -= 4
	if Input.is_action_pressed("right") and xMovement >= -498:
		xMovement += 4
	if Input.is_action_pressed("up") and yMovement <= 498:
		yMovement -= 4
	if Input.is_action_pressed("down") and yMovement >= -498:
		yMovement += 4
	if not (Input.is_action_pressed("left") and Input.is_action_pressed("right")):
		if xMovement >= 2:
			xMovement -= 2
		elif xMovement <= -2:
			xMovement += 2
	if not (Input.is_action_pressed("up") and Input.is_action_pressed("down")):
		if yMovement >= 2:
			yMovement -= 2
		elif yMovement <= -2:
			yMovement += 2
	velocity = Vector2(xMovement, yMovement)

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	if input_direction == Vector2(0, 0) and speed >= 10:
		speed -= 10
	else:
		input_direction2 = input_direction
		if speed <= 498:
			speed += 2
	#print("test")
	velocity = input_direction2 * speed
	print(velocity)
	#print(input_direction)
	#print(speed)

func _physics_process(_delta):
	get_input2()
	move_and_slide()
