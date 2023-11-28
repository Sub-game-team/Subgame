extends RigidBody2D

var speed = 1000

func _process(_delta):
	pass

func _on_timer_timeout():
	queue_free()

func _on_area_2d_area_entered(area):
	if area.is_in_group("enemy"):
		area.get_parent().queue_free()
		queue_free()
