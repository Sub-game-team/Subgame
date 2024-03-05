extends RigidBody2D

var speed = 200
var player
var stop = false
var speedmax = 1600
var speedmaxmod = 1.0
var acc = 10
var accmod = 1
var radiusmod = 1.0
var damage = 5
var damagemod = 1.0
var homing = false
var distancetomouse = [0, 0, 0, 0]
var targetenemy = [0, 0, 0 ,0]
var showtarget = false
var delay = 0.016
var closestenemydistance = 0
var timetoenemy = 0
var targetcoords = Vector2()

func _ready():
	var all_enemy = get_tree().get_nodes_in_group("enemy")
	if not len(all_enemy) == 0:
		distancetomouse.resize(len(all_enemy))
		targetenemy.resize(len(all_enemy))
		for i in range(len(all_enemy)):
			distancetomouse[i] = get_global_mouse_position().distance_squared_to(all_enemy[i].global_position)
		closestenemydistance = distancetomouse.min()
		targetenemy = all_enemy[distancetomouse.find(closestenemydistance)]
		stop = false
	else:
		stop = true

func set_stuff():
	$Area2D/CollisionShape2D.set_scale(Vector2(1*radiusmod, 1*radiusmod))
	damage = max(damage * damagemod, 1)
	acc = acc * accmod
	speedmax = speedmax * speedmaxmod

func _process(_delta):
	if showtarget and ((not stop) and (not (targetenemy == null))) and (homing):
		$Sprite2D2.set_global_position(targetcoords)
	else:
		pass

func _integrate_forces(_state):
	if (not stop) and homing:
		SmoothLookAtRigid(self, targetcoords, delay)
	set_linear_velocity(Vector2(1, 0).rotated(global_rotation) * speed * 1)
	if speed <= speedmax - acc:
		speed += acc

func _on_timer_timeout():
	queue_free()

func set_player_reference(player_ref: CharacterBody2D):
	player = player_ref

func _on_audio_stream_player_2d_finished():
	queue_free()

func _on_body_entered(_body):
	if not stop:
		$AudioStreamPlayer2D.play(0.0)
		var enemys_to_kill = $Area2D.get_overlapping_areas()
		for i in range(len(enemys_to_kill)):
			if enemys_to_kill[i].is_in_group("enemyarea") or enemys_to_kill[i].is_in_group("player"):
				enemys_to_kill[i].get_parent().take_damage(damage)
		set_visible(false)
		stop = true
	else:
		pass
	#call_deferred("set_process_mode", PROCESS_MODE_DISABLED)

func sonar_ping():
	if (not stop) and (not (targetenemy == null)) and homing:
		var targetenemydistancetotorpedo = global_position.distance_to(targetenemy.get_global_position())
		timetoenemy = calculateTimeToHit(targetenemydistancetotorpedo, speed, acc)
		showtarget = true
		targetcoords = targetenemy.get_global_position()# + (targetenemy.get_linear_velocity() * timetoenemy)
	else:
		pass

func SmoothLookAtRigid( nodeToTurn, targetPosition, turnSpeed ):
	nodeToTurn.angular_velocity = max(min((AngularLookAt( nodeToTurn.global_position, nodeToTurn.global_rotation, targetPosition, turnSpeed)), 1.5), -1.5)

func AngularLookAt( currentPosition, currentRotation, targetPosition, turnTime ):
	return GetAngle( currentRotation, TargetAngle( currentPosition, targetPosition ) )/turnTime

func TargetAngle( currentPosition, targetPosition ):
	return (targetPosition - currentPosition).angle()

func GetAngle( currentAngle, targetAngle ):
	return fposmod( targetAngle - currentAngle + PI, PI * 2 ) - PI

func calculateTimeToHit(distance: float, initialSpeed: float, acceleration: float) -> float:
	var a = 0.5 * acceleration
	var b = initialSpeed
	var c = -distance

	var discriminant = b * b - 4 * a * c

	if discriminant < 0:
		# No real roots (object won't hit)
		return -1

	var sqrtDiscriminant = sqrt(discriminant)

	var positiveRoot = (-b + sqrtDiscriminant) / (2 * a)

	# Ignore negative root since time cannot be negative
	return positiveRoot
