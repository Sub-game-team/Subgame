extends CharacterBody2D

var input_direction2
var yMovement = 0
var xMovement = 0
@onready var player_body = get_node(".")
var projectile_scene0 = preload("res://Torpedo0.tscn")
var readyToFire = [true, true, true]
var damage = 0
var flooded = [false, false, false, false, false]
var torpedopenalty = 1
var repairpenalty = 1
var movementpenalty = 1
var poweroutage = false
var reactoroutageoverride = false
var x = 0
var killcount = 0
var activetorpedo = 0
var projectile
var distancetomouse

func get_input():
	if Input.is_action_pressed("left") and xMovement >= -492:
		xMovement -= 8 * movementpenalty
	if Input.is_action_pressed("right") and xMovement <= 492:
		xMovement += 8 * movementpenalty
	if Input.is_action_pressed("up") and yMovement >= -492:
		yMovement -= 8 * movementpenalty
	if Input.is_action_pressed("down") and yMovement <= 492:
		yMovement += 8 * movementpenalty
	if xMovement >= 4 and not Input.is_action_pressed("right"):
		xMovement -= 4
	if xMovement <= -4 and not Input.is_action_pressed("left"):
		xMovement += 4
	if yMovement >= 4 and not Input.is_action_pressed("up"):
		yMovement -= 4
	if yMovement <= -4 and not Input.is_action_pressed("down"):
		yMovement += 4
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
	if Input.is_action_just_pressed("torpedo0"):
		activetorpedo = 0
		$Timer_1torp.set_paused(false)
		$Timer_2torp.set_paused(true)
		$Timer_3torp.set_paused(true)
	if Input.is_action_just_pressed("torpedo1"):
		activetorpedo = 1
		$Timer_1torp.set_paused(true)
		$Timer_2torp.set_paused(false)
		$Timer_3torp.set_paused(true)
	if Input.is_action_just_pressed("torpedo2"):
		activetorpedo = 2
		$Timer_1torp.set_paused(true)
		$Timer_2torp.set_paused(true)
		$Timer_3torp.set_paused(false)
	if Input.is_action_just_pressed("shoot", true) and readyToFire[activetorpedo]:
		readyToFire[activetorpedo] = false
		if activetorpedo == 0:
			$Timer_1torp.start(1 * torpedopenalty)
		elif activetorpedo == 1:
			$Timer_2torp.start(1 * torpedopenalty)
		elif activetorpedo == 2:
			$Timer_3torp.start(1 * torpedopenalty)
		projectile = projectile_scene0.instantiate()
		get_parent().add_child(projectile)
		projectile.global_position = global_position
		projectile.look_at(get_global_mouse_position())
		if not activetorpedo == 2:
			projectile.set_lock_rotation_enabled(true)
		projectile.set_player_reference(self)
	if flooded[0]:
		torpedopenalty = 1.75
	else:
		torpedopenalty = 1
	if flooded[1]:
		repairpenalty = 0.5
	else:
		repairpenalty = 1
	if flooded[3]:
		poweroutage = true
		reactoroutageoverride = true
	else:
		poweroutage = true
		reactoroutageoverride = true
	if flooded[4]:
		movementpenalty = 0.25
	else:
		movementpenalty = 1
	$Label.set_text(str(killcount) + str(readyToFire))

func _physics_process(_delta):
	get_input()
	move_and_slide()

func _on_timer_damagecalculation_timeout():
	pass

func _on_timer_sonar_timeout():
	if x == 5:
		$AudioStreamPlayer2D_sonar.play(0.0)
		x = 0
	else:
		x += 1
	var all_torpedos = get_tree().get_nodes_in_group("sonar_torpedo")
	for i in all_torpedos:
		i.sonar_ping()

func _on_timer_1_torp_timeout():
	readyToFire[0] = true

func _on_timer_2_torp_timeout():
	readyToFire[1] = true

func _on_timer_3_torp_timeout():
	readyToFire[2] = true
