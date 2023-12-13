extends RigidBody2D

var speed = 1
var player
var stop = false

func _process(_delta):
	pass

func _integrate_forces(_state):
	if not stop:
		set_linear_velocity(Vector2(1, 0).rotated(global_rotation) * speed * 1)
	if speed <= 1580:
		speed += 20

func _on_timer_timeout():
	queue_free()

func set_player_reference(player_ref: CharacterBody2D):
	player = player_ref

func _on_audio_stream_player_2d_finished():
	queue_free()

func _on_body_entered(body):
	$AudioStreamPlayer2D.play(0.0)
	if body.is_in_group("enemy"):
		body.queue_free()
		player.killcount += 1
	set_visible(false)
	stop = true
	
