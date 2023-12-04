extends RigidBody2D

var speed = 800
var player
var distancetomouse = [0, 0, 0, 0]
var targetenemy = [0, 0, 0 ,0]
var stop = false

func _process(_delta):
	pass

func _ready():
	var all_enemy = get_tree().get_nodes_in_group("enemy")
	distancetomouse.resize(len(all_enemy))
	targetenemy.resize(len(all_enemy))
	for i in range(len(all_enemy)):
		distancetomouse[i] = get_global_mouse_position().distance_squared_to(all_enemy[i].global_position)
	print(distancetomouse)
	targetenemy = all_enemy[distancetomouse.bsearch(distancetomouse.min())]

func _integrate_forces(_state):
	if not stop:
		SmoothLookAtRigid(self, targetenemy.global_position, 0.01)
	apply_force(transform.x * speed)

func _on_timer_timeout():
	queue_free()

func set_player_reference(player_ref: CharacterBody2D):
	player = player_ref

func _on_audio_stream_player_2d_finished():
	queue_free()

func _on_body_entered(body):
	stop = true
	$AudioStreamPlayer2D.play(0.0)
	if body.is_in_group("enemy"):
		body.queue_free()
		player.killcount += 1
	set_visible(false)


func SmoothLookAtRigid( nodeToTurn, targetPosition, turnSpeed ):
	nodeToTurn.angular_velocity = AngularLookAt( nodeToTurn.global_position, nodeToTurn.global_rotation, targetPosition, turnSpeed )

#-------------------------
# these are only called from above functions
func AngularLookAt( currentPosition, currentRotation, targetPosition, turnTime ):
	return GetAngle( currentRotation, TargetAngle( currentPosition, targetPosition ) )/turnTime
func TargetAngle( currentPosition, targetPosition ):
	return (targetPosition - currentPosition).angle()
func GetAngle( currentAngle, targetAngle ):
	return fposmod( targetAngle - currentAngle + PI, PI * 2 ) - PI
