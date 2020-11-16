extends Area2D


onready var center_ship = get_tree().current_scene.get_node("CenterShip")


func _ready():
	pass # Replace with function body.


const speed = 400


func _process(delta):
	if center_ship == null:
		destroy()
		return
	
	var direction = (center_ship.position - position).normalized()
	position += direction * speed * delta


func destroy():
	var explosion = load("res://Explosion.tscn").instance()
	explosion.position = position
	get_tree().current_scene.add_child(explosion)
	queue_free()
