extends RigidBody2D

var speed = 200.0
var player
var stop = false

func _process(_delta):
	pass

func _integrate_forces(_state):
	if not stop:
		set_linear_velocity(Vector2(1, 0).rotated(global_rotation) * speed * 1)

func _on_timer_timeout():
	queue_free()

func set_player_reference(player_ref: CharacterBody2D):
	player = player_ref

func _on_audio_stream_player_2d_finished():
	queue_free()

func _on_body_entered(_body):
	$AudioStreamPlayer2D.play(0.0)
	var enemys_to_kill = $Area2D.get_overlapping_areas()
	#print(enemys_to_kill)
	for i in range(len(enemys_to_kill)):
		if enemys_to_kill[i].is_in_group("enemyarea"):
			enemys_to_kill[i].get_parent().queue_free()
	player.killcount += len(enemys_to_kill)
	set_visible(false)
	stop = true
