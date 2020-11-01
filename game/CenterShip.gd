extends Area2D


signal center_ship_damaged(damage)


func _on_CenterShip_body_entered(body):
	if body.name.begins_with("Enemy"):
		body.destroy()
		emit_signal("center_ship_damaged", body.health * 5)
