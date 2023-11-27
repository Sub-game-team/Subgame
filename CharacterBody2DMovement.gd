extends CharacterBody2D

var input_direction2
var yMovement = 0
var xMovement = 0
@onready var player_body = get_node(".")

func get_input():
	if Input.is_action_pressed("left") and xMovement >= -498:
		xMovement -= 4
	if Input.is_action_pressed("right") and xMovement <= 498:
		xMovement += 4
	if Input.is_action_pressed("up") and yMovement >= -498:
		yMovement -= 4
	if Input.is_action_pressed("down") and yMovement <= 498:
		yMovement += 4
	if xMovement >= 0 and not Input.is_action_pressed("right"):
		xMovement -= 2
	if xMovement <= 0 and not Input.is_action_pressed("left"):
		xMovement += 2
	if yMovement >= 0 and not Input.is_action_pressed("up"):
		yMovement -= 2
	if yMovement <= 0 and not Input.is_action_pressed("down"):
		yMovement += 2
	velocity = Vector2(xMovement, yMovement)
	print(velocity) #for debug
	print(player_body.get_real_velocity()) #for debug
	if abs(xMovement) >= 10 or abs(yMovement) >= 10:
		if is_on_ceiling() or is_on_floor() or is_on_wall():
			velocity = player_body.get_real_velocity()
			if xMovement >= 20:
				xMovement = 18
			if xMovement <= -20:
				xMovement = -18
			if yMovement >= 20:
				yMovement = 18
			if yMovement <= -20:
				yMovement = -18
	
func _physics_process(_delta):
	get_input()
	move_and_slide()
