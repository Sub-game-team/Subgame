extends RigidBody2D

var speed = 8000
var player

func _process(_delta):
	pass

func _integrate_forces(_state):
        if get_real_velocity() <= transform.x * speed:
	        apply_force(transform.x * speed)

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
