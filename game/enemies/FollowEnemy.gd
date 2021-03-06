extends KinematicBody2D


onready var center_ship = get_tree().current_scene.get_node("CenterShip")


func _ready():
	pass # Replace with function body.


const speed = 80

var health = 1

var booster_seq = 0


func _process(delta):
	booster_seq = fmod(booster_seq + delta * 200, 30)
	$Polygon2DBooster.polygon[2].y = -30 - booster_seq
	
	if position.y > 2000:
		queue_free()
	
	if center_ship == null:
		rotation = 0
		position.y += speed * delta
		return
	
	var angle = position.angle_to_point(center_ship.position)
	rotation = angle + PI / 2
	
	var direction = (center_ship.position - position).normalized()
	position += direction * speed * delta


func hit(damage):
	if damage > 0:
		get_tree().current_scene.call_deferred("enemy_killed", 50)
		destroy()


func destroy():
	var explosion = load("res://Explosion.tscn").instance()
	explosion.position = position
	get_tree().current_scene.add_child(explosion)
	queue_free()
