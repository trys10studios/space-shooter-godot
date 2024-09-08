extends RigidBody2D
const PlayerExplosion = preload("res://Scenes/PlayerExplosion.tscn")
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
	
# Stops rotation of enemy laser
func _integrate_forces(_state):
	rotation = PI
	
func _on_body_entered(body: Node):
	if(body.name.begins_with("P")):
		body.queue_free()
		
		# Instance the explosion scene
		var explosion = PlayerExplosion.instance()
		explosion.position = position  # Position the explosion at the player's position
		get_tree().current_scene.add_child(explosion)	
		
		# Play the explosion sound (assuming it's part of the explosion scene)
		explosion.get_node("AudioStreamPlayer2D").play()
			
		queue_free()
