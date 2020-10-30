extends Area2D


func _on_Bullet_body_entered(body):
	if body.get_name().begins_with("Enemy"):
		body.hit(1)
		queue_free()
