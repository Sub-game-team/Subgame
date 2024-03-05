extends RigidBody2D

var triggerchance: int
var damage = 2
var distancetomouse = [0, 0, 0, 0]
var targetenemy: Node
var player
var speed = 3000

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _integrate_forces(_state):
	constant_force = (Vector2(1, 0).rotated(global_rotation) * speed)

func _on_body_entered(body):
	var closestenemydistance = 0
	if body.is_in_group("enemy"):
		body.take_damage(damage)
		var all_enemy = get_tree().get_nodes_in_group("enemy")
		all_enemy.erase(body)
		if not len(all_enemy) == 0:
			distancetomouse.resize(len(all_enemy))
			for i in range(len(all_enemy)):
				distancetomouse[i] = get_global_mouse_position().distance_squared_to(all_enemy[i].global_position)
			closestenemydistance = distancetomouse.min()
			targetenemy = all_enemy[distancetomouse.find(closestenemydistance)]
	var randomgen = randi() % 100
	if randomgen <= triggerchance and targetenemy != null:
		player.call_deferred("electrogun_shoot", self.get_global_position(), targetenemy.get_global_position(), triggerchance-0)
	queue_free()

func set_player_reference(player_ref: CharacterBody2D):
	player = player_ref

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
