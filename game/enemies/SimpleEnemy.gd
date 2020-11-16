extends KinematicBody2D


func _ready():
	pass # Replace with function body.


const speed = 100

var health = 1

var booster_seq = 0


func _process(delta):
	position.y += speed * delta
	if position.y > 2000:
		queue_free()
	booster_seq = fmod(booster_seq + delta * 200, 30)
	$Polygon2DBooster.polygon[2].y = -30 - booster_seq


func hit(damage):
	if damage > 0:
		get_tree().current_scene.call_deferred("enemy_killed", 10)
		destroy()


func destroy():
	var explosion = load("res://Explosion.tscn").instance()
	explosion.position = position
	get_tree().current_scene.add_child(explosion)
	queue_free()
