extends RigidBody2D

@export var speed = 10
@export var temp_speed = 0
var player: CharacterBody2D
var visual: Sprite2D
var chase = false
var takendamage = 0
var health = 5
var damage = 5
var stop = false
var ping_light = 0.0
var x = 0

var chase_distance = 300

var shader_material : ShaderMaterial = preload("res://Shaders/mob_shader_mat.tres")

func _ready():
	# Assume the Sprite2D node is a direct child named "Sprite2D"
	var sprite_node = $Sprite2D
	sprite_node.material = shader_material
	#shader_material.set_shader_param("tint_color", Color(0.1, 0.69, 0.33, 0.6)) # Set your initial tint color

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		if event.pressed:
			# Right mouse button pressed, activate the shader
			$Sprite2D.material = shader_material
		else:
			# Right mouse button released, deactivate the shader
			$Sprite2D.material = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var y = 0
	$Label.set_text(str(takendamage))
	if takendamage >= health:
		queue_free()
	if x == 1:
		$PointLight2D.set_energy($PointLight2D.get_energy()-0.2)
		y += 1
		if y >= 4:
			x += 1
			y = 0
	if x == 2:
		$PointLight2D.set_energy($PointLight2D.get_energy()+0.05)
		y += 1
		if y >= 16:
			x = 0
			y = 0
	# go in the direction of player
	# look at direction
	# damage
	# retreat a bit
	
# weird hostile fish

func _physics_process(delta):
	if not stop:
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

func take_damage(damagetotake):
	takendamage += damagetotake

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage(damage)
		stop = true
		queue_free()
	else:
		pass
		
func ping():
	x = 1
