extends CanvasLayer


export var score = 0 setget set_score

func set_score(value):
	score = value
	$Score.text = "Score: %010d" % [value]
	pass


export var health = 0 setget set_health

func set_health(value):
	health = value
	$Health.text = "♥ %2d" % [value]


export var wave = 0 setget set_wave

func set_wave(value):
	wave = value
	$Wave.text = "↓ %03d" % [value]


export var killed = 0 setget set_killed

func set_killed(value):
	killed = value
	$Killed.text = "× %d" % [value]
