extends Area2D


func _ready():
	pass # Replace with function body.


func _process(delta):
	position.y += 100 * delta
	if position.y > 2000:
		queue_free()


func _on_PowerUp_area_entered(area):
	if area.get_name().begins_with("Satellite") || area.get_name() == "CenterShip":
		get_tree().current_scene.call_deferred("add_score", 50)
		#get_tree().current_scene.powerup_collected()
		get_tree().current_scene.call_deferred("powerup_collected")
		queue_free()
