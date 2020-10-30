extends Node2D


func _ready():
	pass # Replace with function body.


func _input(event):
	if visible && event is InputEventScreenTouch && event.pressed:
		var pos = event.position
		if (pos.x > $Background/Button1.margin_left && pos.x < $Background/Button1.margin_right
			&& pos.y > $Background/Button1.margin_top && pos.y < $Background/Button1.margin_bottom
			&& $Background/Button1.visible):
			#get_tree().current_scene.add_satellite()
			get_tree().current_scene.call_deferred("add_satellite")
			hide()
		elif (pos.x > $Background/Button2.margin_left && pos.x < $Background/Button2.margin_right
			&& pos.y > $Background/Button2.margin_top && pos.y < $Background/Button2.margin_bottom
			&& $Background/Button2.visible):
			#get_tree().current_scene.increase_fire_rate()
			get_tree().current_scene.call_deferred("increase_fire_rate")
			hide()
		elif (pos.x > $Background/Button3.margin_left && pos.x < $Background/Button3.margin_right
			&& pos.y > $Background/Button3.margin_top && pos.y < $Background/Button3.margin_bottom
			&& $Background/Button3.visible):
			#get_tree().current_scene.repair_center_ship()
			get_tree().current_scene.call_deferred("repair_center_ship")
			hide()


func _on_PowerUpSelect_visibility_changed():
	var gameLoop = get_tree().current_scene
	$Background/Button1.visible = gameLoop.satellite_count < gameLoop.MAX_SATELLITE_COUNT
	$Background/Button2.visible = gameLoop.fire_interval > gameLoop.MIN_FIRE_INTERVAL
	$Background/Button3.visible = gameLoop.center_ship_health < gameLoop.MAX_CENTER_SHIP_HEALTH
