extends Control

onready var score_label = $ScoreLabel
onready var lives_texture = $LivesTexture

func update_score(val):
	score_label.text = "SCORE: " + str(val)

func update_lives(val):
	lives_texture.rect_size.x = val * 37
