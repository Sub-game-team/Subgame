extends CharacterBody2D

var input_direction2
var yMovement = 0
var xMovement = 0
@onready var player_body = get_node(".")
var projectile_scene0 = preload("res://Torpedo0.tscn")
var projectile_scene1 = preload("res://Torpedo1.tscn")
var projectile_scene2 = preload("res://Torpedo2.tscn")
var projectile_scene3 = preload("res://Torpedo3.tscn")
var readyToFire = true
var damage = [0, 0, 0, 0, 0] #max 30
var floodUnits = [0, 0, 0, 0, 0] #max 300
var leak = [0, 0, 0, 0, 0] #0 = no leak; 1 = small leak; 2 = major leak; 3 = big leak;
var flooded = [false, false, false, false, false]
var torpedopenalty = 1
var repairpenalty = 1
var movementpenalty = 1
var poweroutage = false
var reactoroutageoverride = false
var repairUnits = [0, 0, 0, 0, 0]
var draining = 0
var x = 1
var repairmax = 3
var repaircurrent = 0
var killcount = 0
var activetorpedo = 0
var projectile

func get_input():
	if Input.is_action_pressed("left") and xMovement >= -498:
		xMovement -= 2 * movementpenalty
	if Input.is_action_pressed("right") and xMovement <= 498:
		xMovement += 2 * movementpenalty
	if Input.is_action_pressed("up") and yMovement >= -498:
		yMovement -= 2 * movementpenalty
	if Input.is_action_pressed("down") and yMovement <= 498:
		yMovement += 2 * movementpenalty
	if xMovement >= 1 and not Input.is_action_pressed("right"):
		xMovement -= 1
	if xMovement <= -1 and not Input.is_action_pressed("left"):
		xMovement += 1
	if yMovement >= 1 and not Input.is_action_pressed("up"):
		yMovement -= 1
	if yMovement <= -1 and not Input.is_action_pressed("down"):
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
	if Input.is_action_just_pressed("torpedo0"):
		activetorpedo = 0
	if Input.is_action_just_pressed("torpedo1"):
		activetorpedo = 1
	if Input.is_action_just_pressed("torpedo2"):
		activetorpedo = 2
	if Input.is_action_just_pressed("torpedo3"):
		activetorpedo = 3
	if Input.is_action_just_pressed("shoot", true) and readyToFire:
		readyToFire = false
		$Timer.start(3 * torpedopenalty)
		if activetorpedo == 0:
			projectile = projectile_scene0.instantiate()
		if activetorpedo == 1:
			projectile = projectile_scene1.instantiate()
		if activetorpedo == 2:
			projectile = projectile_scene2.instantiate()
		if activetorpedo == 3:
			projectile = projectile_scene3.instantiate()
		get_parent().add_child(projectile)
		projectile.global_position = global_position
		projectile.look_at(get_global_mouse_position())
		#projectile.set_linear_velocity((get_global_mouse_position() - global_position).normalized() * projectile.speed)
		projectile.set_lock_rotation_enabled(true)
		projectile.set_player_reference(self)
	for i in range(len(damage)):
		if damage[i] >= 31:
			damage[i] = 30
		elif damage[i] <= -1:
			damage[i] = 0
		leak[i] = int(damage[i] / 10)
		#activate flood warning visual depending on how severe the leak is
		if floodUnits[i] >= 1200:
			floodUnits[i] = 1200
			flooded[i] = true
		if floodUnits[i] <= 0:
			floodUnits[i] = 0
			flooded[i] = false
	if flooded[0]:
		torpedopenalty = 1.75
		$Sprite2D2.set_visible(true)
	else:
		torpedopenalty = 1
		$Sprite2D2.set_visible(false)
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
	#print(damage)
	#print(floodUnits)
	#print(leak)
	#print(flooded)
	#print(torpedopenalty)
	#print(repairpenalty)
	#print(movementpenalty)
	#print(poweroutage)
	#print(reactoroutageoverride)
	#print(repairUnits)
	#print(draining)
	#print("---")
	#print(repaircurrent)
	$Label.set_text(str(killcount))
	$Label2.set_text(str(damage[0]) + "," + str(floodUnits[0]) + "," + str(repairUnits[0]))
	$Label3.set_text(str(damage[1]) + "," + str(floodUnits[1]) + "," + str(repairUnits[1]))
	$Label4.set_text(str(damage[2]) + "," + str(floodUnits[2]) + "," + str(repairUnits[2]))
	$Label5.set_text(str(damage[3]) + "," + str(floodUnits[3]) + "," + str(repairUnits[3]))
	$Label6.set_text(str(damage[4]) + "," + str(floodUnits[4]) + "," + str(repairUnits[4]))

func _physics_process(_delta):
	get_input()
	move_and_slide()

func _on_timer_timeout():
	readyToFire = true

func _on_timer_damagecalculation_timeout():
	for i in range(len(leak)):
		if floodUnits[i] <= 1199:
			floodUnits[i] += leak[i]*2
		if draining == i + 1:
			if floodUnits[i] <= 0:
				draining = 0
			else:
				floodUnits[i] -= 4
		if x == 4:
			x = 1
			if damage[i] >= 1:
				damage[i] -= repairUnits[i] * repairpenalty
			else:
				repairUnits[i] = 0
		else:
			x += 1

func _on_area_2d_torpedos_area_entered(area):
	if area.is_in_group("enemy"):
		#print("test1")
		if area.is_in_group("damage5"):
			damage[0] += 5
		area.get_parent().queue_free()


func _on_area_2d_crew_area_entered(area):
	if area.is_in_group("enemy"):
		#print("test2")
		if area.is_in_group("damage5"):
			damage[1] += 5
		area.get_parent().queue_free()

func _on_area_2d_3_area_entered(area):
	if area.is_in_group("enemy"):
		#print("test3")
		if area.is_in_group("damage5"):
			damage[2] += 5
		area.get_parent().queue_free()

func _on_area_2d_reactor_area_entered(area):
	if area.is_in_group("enemy"):
		#print("test4")
		if area.is_in_group("damage5"):
			damage[3] += 5
		area.get_parent().queue_free()
		

func _on_area_2d_engine_area_entered(area):
	if area.is_in_group("enemy"):
		#	print("test5")
		if area.is_in_group("damage5"):
			damage[4] += 5
		area.get_parent().queue_free()

func repairfull():
	repaircurrent = 0
	for i in range(len(repairUnits)):
		repaircurrent += repairUnits[i]
	if repaircurrent < repairmax:
		return true
	else:
		return false

func _on_area_2d_torpedos_input_event(_viewport, _event, _shape_idx):
	#print("test11")
	if Input.is_action_just_pressed("repair_add") and repairfull():
		repairUnits[0] += 1
	if Input.is_action_just_pressed("repair_remove"):
		repairUnits[0] -= 1
	if Input.is_action_just_pressed("drain"):
		draining = 1

func _on_area_2d_crew_input_event(_viewport, _event, _shape_idx):
	#print("test12")
	if Input.is_action_just_pressed("repair_add") and repairfull():
		repairUnits[1] += 1
	if Input.is_action_just_pressed("repair_remove") and repairUnits[1] >= 1:
		repairUnits[1] -= 1
	if Input.is_action_just_pressed("drain"):
		draining = 2

func _on_area_2d_input_event(_viewport, _event, _shape_idx):
	#print("test13")
	if Input.is_action_just_pressed("repair_add") and repairfull():
		repairUnits[2] += 1
	if Input.is_action_just_pressed("repair_remove") and repairUnits[2] >= 1:
		repairUnits[2] -= 1
	if Input.is_action_just_pressed("drain"):
		draining = 3
func _on_area_2d_reactor_input_event(_viewport, _event, _shape_idx):
	#print("test14")
	if Input.is_action_just_pressed("repair_add") and repairfull():
		repairUnits[3] += 1
	if Input.is_action_just_pressed("repair_remove") and repairUnits[3] >= 1:
		repairUnits[3] -= 1
	if Input.is_action_just_pressed("drain"):
		draining = 4

func _on_area_2d_engine_input_event(_viewport, _event, _shape_idx):
	#print("test15")
	if Input.is_action_just_pressed("repair_add") and repairfull():
		repairUnits[4] += 1
	if Input.is_action_just_pressed("repair_remove") and repairUnits[4] >= 1:
		repairUnits[4] -= 1
	if Input.is_action_just_pressed("drain"):
		draining = 5
