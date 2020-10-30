extends Node2D

const MAX_SATELLITE_COUNT = 6
const MAX_CENTER_SHIP_HEALTH = 50
const MIN_FIRE_INTERVAL = 0.2

var satellite_type = preload("res://Satellite.tscn")
var bullet_type = preload("res://Bullet.tscn")
var powerup_type = preload("res://PowerUp.tscn")
var enemy_types = [
	preload("res://SimpleEnemy.tscn"),
	preload("res://FastEnemy.tscn"),
	preload("res://StrongEnemy.tscn")
	]

var rng = RandomNumberGenerator.new()
var game_over = false
var score = 0
var satellite_direction = 1
var satellite_count = 1
var center_ship_health = MAX_CENTER_SHIP_HEALTH

var fire_interval = 1.5
var time_to_fire = fire_interval
var bullet_speed = 300

var wave = 1
var enemy_interval = 2.0
var time_to_next_enemy = enemy_interval
var enemy_spawn_width = 160 #280 400
var enemies_spawned = 0
var enemies_killed = 0

func add_score(value_to_add):
	score += value_to_add
	$HUD.score = score


func powerup_collected():
	add_score(100)
	$PowerUpSelect.show()
	pass


func _ready():
	rng.randomize()


func _input(event):
	if event is InputEventScreenTouch && event.pressed && event.position.y > 240:
		satellite_direction *= -1


func _process(delta):
	# enemy spawning
	time_to_next_enemy -= delta
	if time_to_next_enemy < 0:
		time_to_next_enemy += enemy_interval
		create_enemy()
	# bullet spawning
	time_to_fire -= delta
	if time_to_fire < 0:
		time_to_fire += fire_interval
		create_satellite_shots()
	# bullet movement
	move_bullets(delta)


func enemy_killed(score):
	add_score(score)
	enemies_killed += 1
	$HUD.killed = enemies_killed
	if (enemies_killed - 10) % 15 == 0:
		create_powerup()


func create_powerup():
	if game_over:
		return
	var powerup = powerup_type.instance()
	var x = rng.randf_range(-enemy_spawn_width, enemy_spawn_width) + $CenterShip.position.x
	powerup.position = Vector2(x, -40)
	$Powerups.add_child(powerup)


func create_enemy():
	if game_over:
		return
	var enemy = enemy_types[rng.randi_range(0, (wave - 1) % enemy_types.size())].instance()
	var x = rng.randf_range(-enemy_spawn_width, enemy_spawn_width) + $CenterShip.position.x
	enemy.position = Vector2(x, -40)
	enemy.name = "Enemy" + str(enemies_spawned)
	$Enemies.add_child(enemy)
	enemies_spawned += 1
	if enemies_spawned % 20 == 0:
		next_wave()


func next_wave():
	wave += 1
	$HUD.wave = wave
	if (wave - 1) % 3 == 0 && enemy_interval > 0.5:
		enemy_interval -= 0.2


func add_satellite():
	if !$Satellites.has_node("Satellite1"):
		create_satellite(1, 160, 0)
	elif !$Satellites.has_node("Satellite2"):
		create_satellite(2, 280, 0)
	elif !$Satellites.has_node("Satellite3"):
		create_satellite(3, 400, 0)
	elif !$Satellites.has_node("Satellite4"):
		create_satellite(4, 160, $Satellites/Satellite1.angle + PI)
	elif !$Satellites.has_node("Satellite5"):
		create_satellite(5, 280, $Satellites/Satellite2.angle + PI)
	elif !$Satellites.has_node("Satellite6"):
		create_satellite(6, 400, $Satellites/Satellite3.angle + PI)
	recalculate_satellite_infos()


func create_satellite(number, distance, angle):
	var satellite = satellite_type.instance()
	satellite.name = "Satellite" + str(number)
	satellite.distance = distance
	satellite.angle = angle
	$Satellites.add_child(satellite)


func destroy_satellite(satellite):
	var explosion = load("res://Explosion.tscn").instance()
	explosion.position = satellite.position
	add_child(explosion)
	satellite.free()
	recalculate_satellite_infos()


func recalculate_satellite_infos():
	enemy_spawn_width = 0
	for satellite in $Satellites.get_children():
		if satellite.distance > enemy_spawn_width:
			enemy_spawn_width = satellite.distance
	satellite_count = $Satellites.get_child_count()
	if (satellite_count == 0):
		queue_game_over()


func create_satellite_shots():
	for satellite in $Satellites.get_children():
		var bullet = bullet_type.instance()
		bullet.position = satellite.position + $Satellites.position
		$Bullets.add_child(bullet)


func increase_fire_rate():
	if fire_interval > MIN_FIRE_INTERVAL:
		fire_interval /= 2


func move_bullets(delta):
	for bullet in $Bullets.get_children():
		bullet.position.y = bullet.position.y - bullet_speed * delta
		if bullet.position.y < 0:
			bullet.queue_free()


func _on_CenterShip_body_entered(body):
	if body.name.begins_with("Enemy"):
		body.destroy()
		damage_center_ship(body.health * 5)


func damage_center_ship(damage):
	center_ship_health = clamp(center_ship_health - damage, 0, MAX_CENTER_SHIP_HEALTH)
	$HUD.health = center_ship_health
	if center_ship_health <= 0:
		queue_game_over()
	elif center_ship_health <= 10:
		create_damage_fire(10,-30)
	elif center_ship_health <= 20:
		create_damage_fire(-15,30)
	elif center_ship_health <= 30:
		create_damage_fire(-30,-10)
	elif center_ship_health <= 40:
		create_damage_fire(20,40)


func repair_center_ship():
	center_ship_health = 50
	$HUD.health = center_ship_health
	for child in $CenterShip.get_children():
		if child.name.find ("DamageFire") > -1:
			child.queue_free()

func queue_game_over():
	game_over = true
	$PowerUpSelect.hide()
	for num in (30):
		var explosion = load("res://Explosion.tscn").instance()
		explosion.position = Vector2(rng.randf_range(-50, 50) + $CenterShip.position.x, rng.randf_range(-50, 100) + $CenterShip.position.y)
		add_child(explosion)
	for sat in $Satellites.get_children():
		var explosion = load("res://Explosion.tscn").instance()
		explosion.position = sat.position + $Satellites.position
		add_child(explosion)
		sat.queue_free()
	$CenterShip.queue_free()
	$GameOver.show()
	pass


func create_damage_fire(x, y):
	var fire = load("res://DamageFire.tscn").instance()
	fire.position = Vector2(x,y)
	$CenterShip.add_child(fire)


func _on_TryAgainButton_pressed():
	get_tree().reload_current_scene()
