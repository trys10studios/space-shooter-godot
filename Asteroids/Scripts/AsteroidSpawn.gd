extends Node2D

const ASTEROID_SMALL = preload("res://Scenes/AsteroidSmall.tscn")
const ASTEROID_BIG = preload("res://Scenes/AsteroidBig.tscn")
const ENEMY = preload("res://Scenes/Enemy.tscn")
var asteroid_small
var asteroid_big
var enemy
var i = 0
var j = 0
var timer = 0
var wait_time = 1.0
var rand_num

func _process(delta):
	timer += delta
	while i < 9 && timer > wait_time:
		create_asteroids()
		i += 1
		timer = 0
	while j < 1 && timer > wait_time:
		create_enemies()
		j += 1
		timer = 0
		
func create_asteroids():
	asteroid_small = ASTEROID_SMALL.instance()
	asteroid_big = ASTEROID_BIG.instance()
	var asteroids = [asteroid_small, asteroid_big]
	var curr_asteroid = asteroids[randi() % asteroids.size() - 1]
	var main = get_tree().current_scene
	main.add_child(curr_asteroid)
	curr_asteroid.global_position = self.position
	
func create_enemies():
	enemy = ENEMY.instance()
	var main = get_tree().current_scene
	main.add_child(enemy)
	enemy.global_position = self.position
