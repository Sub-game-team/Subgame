extends CharacterBody2D

var input_direction2
var yMovement = 0
var xMovement = 0
@onready var player_body = get_node(".")
var projectile_scene = preload("res://Torpedo.tscn")
var readyToFire = true
var damage = 0
var floodUnits = 0
var flooded = false

func get_input():
	if Input.is_action_pressed("left") and xMovement >= -498:
		xMovement -= 2
	if Input.is_action_pressed("right") and xMovement <= 498:
		xMovement += 2
	if Input.is_action_pressed("up") and yMovement >= -498:
		yMovement -= 2
	if Input.is_action_pressed("down") and yMovement <= 498:
		yMovement += 2
	if xMovement >= 0 and not Input.is_action_pressed("right"):
		xMovement -= 1
	if xMovement <= 0 and not Input.is_action_pressed("left"):
		xMovement += 1
	if yMovement >= 0 and not Input.is_action_pressed("up"):
		yMovement -= 1
	if yMovement <= 0 and not Input.is_action_pressed("down"):
		yMovement += 1
	velocity = Vector2(xMovement, yMovement)
	#print(velocity) #for debug
	#print(player_body.get_real_velocity()) #for debug
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

func _process(_delta):
	if Input.is_action_just_pressed("shoot") and readyToFire:
		readyToFire = false
		$Timer.start(3)
		var projectile = projectile_scene.instantiate()
		get_parent().add_child(projectile)
		projectile.global_position = global_position
		projectile.look_at(get_global_mouse_position())
		projectile.set_linear_velocity((get_global_mouse_position() - global_position).normalized() * projectile.speed)
		projectile.set_lock_rotation_enabled(true)

func _physics_process(_delta):
	get_input()
	move_and_slide()

func _on_timer_timeout():
	readyToFire = true

func _on_area_2d_torpedos_area_entered(area):
	if area.is_in_group("enemy"):
		print("test1")
		area.get_parent().queue_free()
		

func _on_area_2d_crew_area_entered(area):
	if area.is_in_group("enemy"):
		print("test2")

func _on_area_2d_reactor_area_entered(area):
	if area.is_in_group("enemy"):
		print("test3")

func _on_area_2d_engine_area_entered(area):
	if area.is_in_group("enemy"):
		print("test4")
