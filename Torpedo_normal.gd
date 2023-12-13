extends RigidBody2D

var speed = 1
var player
var stop = false
var speedmax = 1600
var acc = 10
var radiusmod = 1
var damage = 5
var homing = false
var distancetomouse = [0, 0, 0, 0]
var targetenemy = [0, 0, 0 ,0]
var showtarget = false
var delay = 0.8
var closestenemydistance = 0
var timetoenemy = 0
var targetcoords = Vector2()

func _ready():
	$Area2D/CollisionShape2D.draw_set_transform(position, rotation, scale * radiusmod)
	var all_enemy = get_tree().get_nodes_in_group("enemy")
	if not len(all_enemy) == 0:
		distancetomouse.resize(len(all_enemy))
		targetenemy.resize(len(all_enemy))
		for i in range(len(all_enemy)):
			distancetomouse[i] = get_global_mouse_position().distance_squared_to(all_enemy[i].global_position)
		#print(distancetomouse)
		closestenemydistance = distancetomouse.min()
		targetenemy = all_enemy[distancetomouse.find(closestenemydistance)]
		stop = false
	else:
		stop = true

func _process(_delta):
	if showtarget and ((not stop) and (not (targetenemy == null))) and (homing):
		$Sprite2D2.set_global_position(targetcoords)
	else:
		pass

func _integrate_forces(_state):
	if not stop:
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
	$AudioStreamPlayer2D.play(0.0)
	var enemys_to_kill = $Area2D.get_overlapping_areas()
	print(enemys_to_kill)
	for i in range(len(enemys_to_kill)):
		if enemys_to_kill[i].is_in_group("enemyarea"):
			enemys_to_kill[i].get_parent().queue_free()
	player.killcount += len(enemys_to_kill)
	set_visible(false)
	stop = true


func sonar_ping():
	if (not stop) and (not (targetenemy == null)):
		var targetenemydistancetotorpedo = global_position.distance_to(targetenemy.get_global_position())
		timetoenemy = targetenemydistancetotorpedo / speed
		#print(timetoenemy)
		showtarget = true
		targetcoords = targetenemy.get_global_position() + (targetenemy.get_linear_velocity() * timetoenemy)

func SmoothLookAtRigid( nodeToTurn, targetPosition, turnSpeed ):
#print(AngularLookAt( nodeToTurn.global_position, nodeToTurn.global_rotation, targetPosition, turnSpeed))
	nodeToTurn.angular_velocity = min((AngularLookAt( nodeToTurn.global_position, nodeToTurn.global_rotation, targetPosition, turnSpeed)), 0.5)

#-------------------------
# these are only called from above functions
func AngularLookAt( currentPosition, currentRotation, targetPosition, turnTime ):
	return GetAngle( currentRotation, TargetAngle( currentPosition, targetPosition ) )/turnTime
func TargetAngle( currentPosition, targetPosition ):
	return (targetPosition - currentPosition).angle()
func GetAngle( currentAngle, targetAngle ):
	return fposmod( targetAngle - currentAngle + PI, PI * 2 ) - PI
