extends KinematicBody2D


func _ready():
	pass # Replace with function body.


var health = 10


func _process(delta):
	position.y += 90 * delta
	if position.y > 2000:
		queue_free()


func hit(damage):
	health -= damage
	if health <= 0:
		get_tree().current_scene.call_deferred("add_score", 20)
		destroy()
	elif health <= 5:
		var fire = load("res://DamageFire.tscn").instance()
		fire.rotation = PI
		add_child(fire)


func destroy():
	var explosion = load("res://Explosion.tscn").instance()
	explosion.position = position
	get_tree().current_scene.add_child(explosion)
	queue_free()
