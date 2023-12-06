extends RigidBody2D

var speed = 300.0
var player
var distancetomouse = [0, 0, 0, 0]
var targetenemy = [0, 0, 0 ,0]
var stop = true
var showtarget = false
var delay = 0.8
var closestenemydistance = 0
var timetoenemy = 0
var targetcoords = Vector2()

func _process(_delta):
	if showtarget and ((not stop) and (not (targetenemy == null))):
		$Sprite2D2.set_global_position(targetcoords)
	else:
		pass

func _ready():
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
func _integrate_forces(_state):
	if (not stop) and (not (targetenemy == null)):
		SmoothLookAtRigid(self, targetcoords, delay)
	set_linear_velocity(Vector2(1, 0).rotated(global_rotation) * speed * 1)

func _on_timer_timeout():
	queue_free()

func set_player_reference(player_ref: CharacterBody2D):
	player = player_ref

func _on_audio_stream_player_2d_finished():
	queue_free()

func _on_body_entered(body):
	if not stop:
		stop = true
		$AudioStreamPlayer2D.play(0.0)
		if body.is_in_group("enemy"):
			body.queue_free()
			player.killcount += 1
		set_visible(false)

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
