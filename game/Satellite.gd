extends Area2D


export var angle = 1.0
export var distance = 160

var speed = 1.0
var target_angle = 0

var health = 5


func _ready():
	speed = (500.0 - distance) / 250.0


func _process(delta):
	var satellite_direction = get_tree().current_scene.satellite_direction
	#$CPUParticles2D.direction.y = satellite_direction
	angle += speed * delta * satellite_direction
	if angle >= 2 * PI:
		angle -= 2 * PI
	elif angle < 0:
		angle += 2 * PI
	
	position = Vector2(cos(angle) * distance,sin(angle) * distance)
	
	target_angle = angle + (PI * (satellite_direction + 1) / 2)
	if target_angle > 2 * PI:
		target_angle -= 2 * PI
	if target_angle < 0:
		target_angle += 2 * PI
	
	if abs(target_angle - rotation) > PI:
		if target_angle > PI:
			rotation += 2 * PI
		else:
			rotation -= 2 * PI
	
	rotation = lerp(rotation, target_angle, delta * 20)


func _on_Satellite_body_entered(body):
	if body.name.begins_with("Enemy"):
		damage_satellite(body.health)
		body.destroy()


func damage_satellite(damage):
	health -= damage
	if health <= 0:
		get_tree().current_scene.call_deferred("destroy_satellite", self)
