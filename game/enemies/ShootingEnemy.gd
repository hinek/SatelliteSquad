extends KinematicBody2D


onready var center_ship = get_tree().current_scene.get_node("CenterShip")


func _ready():
	pass # Replace with function body.


const speed = 80
const shoot_interval = 3.0

var health = 1
var booster_seq = 0
var time_to_next_shot = shoot_interval


func _process(delta):
	position.y += speed * delta
	booster_seq = fmod(booster_seq + delta * 200, 30)
	$Polygon2DBooster.polygon[2].y = -30 - booster_seq
	
	if position.y > 2000:
		queue_free()
	
	if center_ship == null:
		return
	
	var angle = position.angle_to_point(center_ship.position)
	$Cannon.rotation = angle + PI / 2
	
	time_to_next_shot -= delta
	if time_to_next_shot <= 0:
		var bullet = load("res://enemies/EnemyBullet.tscn").instance()
		bullet.position = position
		bullet.name = "EnemyBullet" + str(OS.get_ticks_msec())
		get_tree().current_scene.get_node("Enemies").add_child(bullet)
		time_to_next_shot += shoot_interval


func hit(damage):
	if damage > 0:
		get_tree().current_scene.call_deferred("enemy_killed", 10)
		destroy()


func destroy():
	var explosion = load("res://Explosion.tscn").instance()
	explosion.position = position
	get_tree().current_scene.add_child(explosion)
	queue_free()
