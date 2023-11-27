extends RigidBody2D

var speed = 1000

func _process(_delta):
	pass

func _on_timer_timeout():
	queue_free()
