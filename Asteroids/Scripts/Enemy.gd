extends RigidBody2D

var rand_num
const EnemyLaser = preload("res://Scenes/EnemyLaser.tscn")
var timer = Timer.new()
# Assuming the AudioStreamPlayer2D node is a direct child
onready var hit_sound = $AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready():

	rand_num = random()
	
	# Set rotation of the asteroid according
	# to the angle of the spawner it is a child of
	if(rotation == 0 || rotation == PI):
		position = Vector2(position.x, rand_num)
	if(rotation == PI/2 || rotation == 3*PI/2):
		position = Vector2(rand_num, position.y)

	if(rand_num % 10 >= 0 && rand_num % 10 < 2):
		position += Vector2(rand_num % 100, 0)
	elif(rand_num % 10 >= 2 && rand_num % 10 < 4):
		position += Vector2(-rand_num % 100, 0)
	elif(rand_num % 10 >= 4 && rand_num % 10 < 6):
		position += Vector2(0, rand_num % 100)
	elif(rand_num % 10 >= 6 && rand_num % 10 < 8):
		position += Vector2(0, -rand_num % 100)
	elif(rand_num % 10 >= 8 && rand_num % 10 <= 9):
		position += Vector2(rand_num % 100, rand_num % 100)
	elif(rand_num % 10 + 2 >= 10 && rand_num % 10 + 2 < 8):
		position += Vector2(-rand_num % 100, -rand_num % 100)
		
	self.add_child(timer)
	# Connect the timer to make it call "queue_free" after two seconds
	timer.connect("timeout", self, "shoot_laser")
	timer.set_wait_time(1)
	timer.start()

# Stops rotation of enemy ship
func _integrate_forces(_state):
	rotation = 0
	
func _process(_delta):
	# If the asteroid goes off screen, reset its position
	if(global_position.y > 650):
		global_position = Vector2(rand_num, -25)
	elif(global_position.y < -50):
		global_position = Vector2(rand_num, 650)
	elif(global_position.x > 1075):
		global_position = Vector2(-25, rand_num)
	elif(global_position.x < -50):
		global_position = Vector2(1075, rand_num)
	
func random():
	rand_num = randi() % 100
	return rand_num
	
func shoot_laser():
	var main = get_tree().current_scene
	var enemy_laser = EnemyLaser.instance()
	main.add_child(enemy_laser)
	var enemy_laser_spawn = get_node("EnemyLaserSpawn")
	enemy_laser.rotation = enemy_laser_spawn.global_rotation
	enemy_laser.position = enemy_laser_spawn.global_position
	var impulse_strength = 100
	var angle = rotation + PI/2
	enemy_laser.apply_central_impulse(Vector2(cos(angle), sin(angle)) * impulse_strength)
