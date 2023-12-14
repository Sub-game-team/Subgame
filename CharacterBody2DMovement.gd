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
var homingupgrade = [false, true, false]
var speedupgrade = [true, false, false]
var damageupgrade = [false, false, true]
var radiusupgrade = [false, false, true]
var health = 30

func get_input():
	if Input.is_action_pressed("left") and xMovement >= -488:
		xMovement -= 8 * movementpenalty
	if Input.is_action_pressed("right") and xMovement <= 488:
		xMovement += 8 * movementpenalty
	if Input.is_action_pressed("up") and yMovement >= -488:
		yMovement -= 8 * movementpenalty
	if Input.is_action_pressed("down") and yMovement <= 488:
		yMovement += 8 * movementpenalty
	if xMovement >= 4 and not Input.is_action_pressed("right"):
		xMovement -= 4
	if xMovement <= -4 and not Input.is_action_pressed("left"):
		xMovement += 4
	if yMovement >= 4 and not Input.is_action_pressed("up"):
		yMovement -= 4
	if yMovement <= -4 and not Input.is_action_pressed("down"):
		yMovement += 4
	if abs(yMovement) == 2:
		yMovement = 0
	if abs(xMovement) == 2:
		xMovement = 0
	velocity = Vector2(xMovement, yMovement)
	
	print("x")
	print(yMovement)
	print("y")
	print(xMovement)
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
		if speedupgrade[activetorpedo]:
			projectile.speedmaxmod += 0.25
			projectile.accmod += 0.5
			projectile.damagemod -= 0.4
		if homingupgrade[activetorpedo]:
			projectile.homing = true
			projectile.damagemod -= 0.4
			projectile.accmod -= 0.2
		if radiusupgrade[activetorpedo]:
			projectile.radiusmod += 0.75
			projectile.damagemod += 0.2
			projectile.accmod -= 0.2
		if damageupgrade[activetorpedo]:
			projectile.damagemod += 1
			projectile.speedmaxmod -= 0.5
			projectile.accmod -= 0.25
		projectile.set_stuff()
		projectile.global_position = global_position
		projectile.look_at(get_global_mouse_position())
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
	$Label.set_text(str(killcount) + str(readyToFire) + str(health))
	var all_torpedos = get_tree().get_nodes_in_group("torpedo")
	for i in all_torpedos:
		i.sonar_ping()
	if health <= 0:
		queue_free()

func _physics_process(_delta):
	get_input()
	move_and_slide()

func _on_timer_damagecalculation_timeout():
	pass

func _on_timer_sonar_timeout():
	$AudioStreamPlayer2D_sonar.play(0.0)

func _on_timer_1_torp_timeout():
	readyToFire[0] = true

func _on_timer_2_torp_timeout():
	readyToFire[1] = true

func _on_timer_3_torp_timeout():
	readyToFire[2] = true

func take_damage(damagetotake):
	health -= damagetotake
