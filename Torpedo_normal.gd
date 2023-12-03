extends RigidBody2D

var speed = 500
var player

func _process(_delta):
	pass

func _on_timer_timeout():
	queue_free()

func _on_area_2d_area_entered(area):
	if area.is_in_group("enemy") or area.is_in_group("wall"):
		area.get_parent().queue_free()
		player.killcount += 1
		queue_free()

func set_player_reference(player_ref: CharacterBody2D):
	player = player_ref
