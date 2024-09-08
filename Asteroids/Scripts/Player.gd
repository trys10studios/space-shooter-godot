extends RigidBody2D

export var engine_thrust = 200
export var spin_thrust = 500

var offset = Vector2(0, -30)

var thrust = Vector2()
var rotation_dir = 0
var screensize
var thrusting = false

const PlayerLaser = preload("res://Scenes/LaserPlayer.tscn")
# Reference to the Sprite node
onready var flame_sprite = $FlamesSprite

func _ready():
	screensize = get_viewport().get_visible_rect().size
	self.connect("finished", self, "sound_finished");
	# Ensure the flame sprite is initially off
	flame_sprite.visible = false

func _get_input():
	if Input.is_action_pressed("ui_up"):
		thrust = transform.y * -engine_thrust
		thrusting = true
	else:
		thrust = Vector2()
		thrusting = false
		$AudioStreamPlayer2D.stop()
	rotation_dir = 0
	if Input.is_action_pressed("ui_right"):
		rotation_dir += 1
	if Input.is_action_pressed("ui_left"):
		rotation_dir -= 1
	if Input.is_action_just_pressed("ui_down"):
		_fire_laser()

func _process(_delta):	
	_get_input()
	_border()
	_play_sound()
	
func _physics_process(_delta):
	applied_force = thrust
	applied_torque = rotation_dir * spin_thrust
	
func _fire_laser():
	var main = get_tree().current_scene
	var player_laser = PlayerLaser.instance()
	main.add_child(player_laser)
	var player_laser_spawn = get_node("PlayerLaserSpawn")
	player_laser.rotation = player_laser_spawn.global_rotation
	player_laser.position = player_laser_spawn.global_position
	var impulse_strength = 200
	var angle = rotation + PI/2
	player_laser.apply_central_impulse(Vector2(cos(angle), sin(angle)) * -impulse_strength)

func _play_sound():
	if thrusting:
		if not $AudioStreamPlayer2D.playing:
			$AudioStreamPlayer2D.play()
		flame_sprite.visible = true
	else:
		if $AudioStreamPlayer2D.playing:
			$AudioStreamPlayer2D.stop()			
		flame_sprite.visible = false
			
func _border():
	# Left
	if(global_position.x < 40):
		global_position = Vector2(40, global_position.y)
		linear_velocity = Vector2(0, linear_velocity.y)
	# Right
	if(global_position.x > 980):
		global_position = Vector2(980, global_position.y)
		linear_velocity = Vector2(0, linear_velocity.y)
	# Top
	if(global_position.y < 40):
		global_position = Vector2(global_position.x, 40)
		linear_velocity = Vector2(linear_velocity.x, 0)
	# Bottom
	if(global_position.y > 580):
		global_position = Vector2(global_position.x, 580)
		linear_velocity = Vector2(linear_velocity.x, 0)
