extends RigidBody2D

@export var speed = 10
@export var temp_speed = 0
var player: CharacterBody2D
var visual: Sprite2D
var chase = false

var chase_distance = 300

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	# go in the direction of player
	# look at direction
	# damage
	# retreat a bit
	
# weird hostile fish

func _physics_process(delta):
	var direction = (player.global_position - global_position).angle() + 180 - 45
	rotation += clampf(direction - rotation,-170,170)
	linear_velocity = Vector2(-10.0,0.0).rotated(direction) * (speed + temp_speed)
	# maybe save the points where to go in a list and thereby follow the player?
	# later
	#print("Distance: ", player.global_position.distance_to(global_position), ", temporary speed: ", temp_speed, ", chase: ", chase)
	if player.global_position.distance_to(global_position) <= chase_distance and not chase:
		chase = true
		temp_speed += 10
	elif player.global_position.distance_to(global_position) > chase_distance and chase:
		chase = false
		
	if temp_speed > 0:
		temp_speed -= 1 * delta

# Function to set the player reference
func set_player_reference(player_ref: CharacterBody2D):
	player = player_ref
