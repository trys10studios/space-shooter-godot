extends RigidBody2D

var rand_num

func _ready():
	
	rand_num = random()	
	# Set rotation of the asteroid according
	# to the angle of the spawner it is a child of
	if(rotation == 0 || rotation == PI):
		position = Vector2(position.x, rand_num)
	if(rotation == PI/2 || rotation == 3*PI/2):
		position = Vector2(rand_num, position.y)

	if(rand_num % 10 >= 0 && rand_num % 10 < 2):
		apply_impulse(position, Vector2(rand_num % 100, 0))
	elif(rand_num % 10 >= 2 && rand_num % 10 < 4):
		apply_impulse(position, Vector2(-rand_num % 100, 0))
	elif(rand_num % 10 >= 4 && rand_num % 10 < 6):
		apply_impulse(position, Vector2(0, rand_num % 100))
	elif(rand_num % 10 >= 6 && rand_num % 10 < 8):
		apply_impulse(position, Vector2(0, -rand_num % 100))
	elif(rand_num % 10 >= 8 && rand_num % 10 <= 9):
		apply_impulse(position, Vector2(rand_num % 100, rand_num % 100))
	elif(rand_num % 10 + 2 >= 10 && rand_num % 10 + 2 < 8):
		apply_impulse(position, Vector2(-rand_num % 100, -rand_num % 100))

func _process(_delta):
	# If the asteroid goes off screen, reset its position
	if(global_position.y > 620):
		global_position = Vector2(rand_num, -10)
	elif(global_position.y < -10):
		global_position = Vector2(rand_num, 620)
	elif(global_position.x > 1045):
		global_position = Vector2(-10, rand_num)
	elif(global_position.x < -10):
		global_position = Vector2(1045, rand_num)
	
func random():
	rand_num = randi() % 1000
	return rand_num
