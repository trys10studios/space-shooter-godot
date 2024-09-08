extends RigidBody2D
# Preload the explosion scene
const Explosion = preload("res://Scenes/Explosion.tscn")

var scoreLabel
var score = 0
var main

# Called when the node enters the scene tree for the first time.
func _ready():
# warning-ignore:return_value_discarded
	connect("body_entered", self, "_on_body_entered")
	
	# Add a timer to this node
	var timer = Timer.new()
	self.add_child(timer)

	# Connect the timer to make it call "queue_free" after two seconds
	timer.connect("timeout", self, "queue_free")
	timer.set_wait_time(3)
	timer.start()
	
	main = get_tree().current_scene
	scoreLabel = main.get_node("Label")
	
func _on_body_entered(body: Node):
	score = scoreLabel.text
	score = int(score)
	score += 1
	scoreLabel.text = "Score: " + str(score)
	 # Destroy the body that collided with the enemy (e.g., the player's laser)
	body.queue_free()
	
	# Instance the explosion scene
	var explosion = Explosion.instance()
	explosion.position = position  # Position the explosion at the enemy's position
	get_tree().current_scene.add_child(explosion)
	
	# Play the explosion sound (assuming it's part of the explosion scene)
	explosion.get_node("AudioStreamPlayer2D").play()
	
	# Destroy the enemy
	queue_free()
