extends CharacterBody2D

var input_direction2
var yMovement = 0
var xMovement = 0
@onready var player_body = get_node(".")
var projectile_scene0 = preload("res://Torpedo0.tscn")
var readyToFire = [true, true, true]
var damage = 0
var flooded = [false, false, false]
var torpedopenalty = 1
var repairpenalty = 1
var movementpenalty = 1
var poweroutage = false
var killcount = 0
var activetorpedo = 0
var activetorpedocooldown = [0, 0, 0]
var projectile
var distancetomouse
var homingupgrade = [false, true, false]
var speedupgrade = [true, false, false]
var damageupgrade = [false, false, true]
var radiusupgrade = [false, false, true]
var currenthealth = 30
var maxhealth = 30
var repairready = false
var healing = false
var inv_ressources = [0, 0] #iron,

func _ready():
	torpedo_cooldown()

func get_movement():
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
	if yMovement <= -4 and not Input.is_action_pressed("up"):
		yMovement += 4
	if yMovement >= 4 and not Input.is_action_pressed("down"):
		yMovement -= 4
	if abs(yMovement) == 2:
		yMovement = 0
	if abs(xMovement) == 2:
		xMovement = 0
	velocity = Vector2(xMovement, yMovement)
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
	torpedo_select_input()
	torpedo_shoot_input()
	variable_processing()
	visualizeanddebug()
	torpedo_ping()
	checkhealth()
	repair()
	collect_ressources()

func torpedo_cooldown():
	for i in range(len(homingupgrade)):
		if homingupgrade[i]:
			activetorpedocooldown[i] += 2
		if damageupgrade[i]:
			activetorpedocooldown[i] += 3
		if radiusupgrade[i]:
			activetorpedocooldown[i] += 2
		if speedupgrade[i]:
			activetorpedocooldown[i] += 0

func torpedo_select_input():
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

func torpedo_shoot_input():
	if Input.is_action_just_pressed("shoot", true) and readyToFire[activetorpedo]:
		readyToFire[activetorpedo] = false
		if activetorpedo == 0:
			$Timer_1torp.start((1+activetorpedocooldown[0])*torpedopenalty)
		elif activetorpedo == 1:
			$Timer_2torp.start((1+activetorpedocooldown[1])*torpedopenalty)
		elif activetorpedo == 2:
			$Timer_3torp.start((1+activetorpedocooldown[2])* torpedopenalty)
		projectile = projectile_scene0.instantiate()
		get_parent().add_child(projectile)
		if speedupgrade[activetorpedo]:
			projectile.speedmaxmod += 0.25
			projectile.accmod += 2
			projectile.damagemod -= 0.6
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

func variable_processing():
	if flooded[0]:
		torpedopenalty = 1.75
	else:
		torpedopenalty = 1
	if flooded[1]:
		poweroutage = true
		$PointLight2D.change_flashlight_energy(-0.01)
	else:
		poweroutage = false
		$PointLight2D.change_flashlight_energy(0.01)
	if flooded[2]:
		movementpenalty = 0.5
	else:
		movementpenalty = 1

func visualizeanddebug():
	$Label.set_text("killcount: " + str(killcount) + "\n" + "torpedoready:" + str(readyToFire) + "\n" + "health: " + str(currenthealth) + "\n" + "repair ready in: " + str(int($Timer_repaircooldown.get_time_left())) + "\n" + "broken parts:" + str(flooded))

func torpedo_ping():
	var all_torpedos = get_tree().get_nodes_in_group("torpedo")
	for i in all_torpedos:
		i.sonar_ping()

func checkhealth():
	if currenthealth <= 0:
		OS.kill(OS.get_process_id())

func repair():
	if Input.is_action_just_pressed("repair") and repairready:
		repairready = false
		$Timer_repaircooldown.start()
		for i in range(len(flooded)):
			flooded[i] = false

func collect_ressources():
	var ressourcestocollect = $Area2D_ressourcecollect.get_overlapping_areas()
	if not (ressourcestocollect == null):
		for i in ressourcestocollect:
			if i.is_in_group("iron"):
				heal(5)
			i.queue_free()

func _physics_process(_delta):
	get_movement()
	move_and_slide()

func _on_timer_sonar_timeout():
	$AudioStreamPlayer2D_sonar.play(0.0)
	var all_enemies = get_tree().get_nodes_in_group("enemy")
	for i in all_enemies:
		i.ping()

func _on_timer_1_torp_timeout():
	readyToFire[0] = true

func _on_timer_2_torp_timeout():
	readyToFire[1] = true

func _on_timer_3_torp_timeout():
	readyToFire[2] = true

func take_damage(damagetotake):
	currenthealth -= damagetotake
	var randomgen = (randi() % 19)
	randomgen = 1
	if randomgen <= 2:
		flooded[randomgen] = true
	healing = false
	$Timer_regen.start()

func _on_timer_repaircooldown_timeout():
	repairready = true

func _on_timer_regen_timeout():
	healing = true
	$Timer_regen2.start()

func _on_timer_regen_2_timeout():
	if healing:
		if currenthealth < maxhealth:
			currenthealth += 1
		$Timer_regen2.start()

func heal(toheal: int):
	currenthealth += toheal
	if currenthealth > maxhealth:
		currenthealth = maxhealth
