extends CanvasLayer


export var score = 0 setget set_score

func set_score(value):
	score = value
	$Score.text = "Score: %010d" % [value]
	pass


export var health = 0 setget set_health

func set_health(value):
	health = value
	$Health.text = "Health: %2d" % [value]
