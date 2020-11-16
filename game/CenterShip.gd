extends Area2D


signal center_ship_damaged(damage)


var booster_seq = 0


func _process(delta):
	booster_seq = fmod(booster_seq + delta * 200, 30)
	$Polygon2DBooster1.polygon[1].y = 60 - booster_seq
	$Polygon2DBooster2.polygon[1].y = 60 - booster_seq


func _on_CenterShip_body_entered(body):
	if body.name.begins_with("Enemy"):
		body.destroy()
		emit_signal("center_ship_damaged", body.health * 5)


func _on_CenterShip_area_entered(area):
	if area.name.begins_with("EnemyBullet"):
		area.destroy()
		emit_signal("center_ship_damaged", 1)
