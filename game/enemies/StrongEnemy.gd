extends KinematicBody2D


func _ready():
	pass # Replace with function body.


const speed = 80

var health = 10

var booster_seq = 0

func _process(delta):
	position.y += speed * delta
	if position.y > 2000:
		queue_free()
	booster_seq = fmod(booster_seq + delta * 200, 30)
	$Polygon2DBooster.polygon[2].y = -30 - booster_seq


func hit(damage):
	health -= damage
	if health <= 0:
		get_tree().current_scene.call_deferred("enemy_killed", 100)
		destroy()
	elif health <= 5:
		var fire = load("res://DamageFire.tscn").instance()
		fire.position = Vector2(rand_range(-10, 10), rand_range(-10, 10))
		fire.rotation = PI
		add_child(fire)


func destroy():
	var explosion_type = load("res://Explosion.tscn")
	for i in range(3):
		var explosion = explosion_type.instance()
		explosion.position = position + Vector2(rand_range(-10, 10), rand_range(-10, 10))
		get_tree().current_scene.add_child(explosion)
	queue_free()
