extends Node2D

onready var hud = $UILayer/HUD
onready var enemy_spawner = $EnemySpawner
onready var ui_layer = $UILayer
onready var explosion_effect = $EffectsLayer/Explosion

var score = 0

var GameOver = preload("res://UI/GameOverMenu.tscn")

func _ready():
	update_score_and_hud(0)
	hud.update_lives($Player.hp)

func spawn_laser(Laser, location):
	var laser = Laser.instance()
	add_child(laser)
	laser.global_position = location

func _on_EnemySpawner_spawn_enemy(EnemyScene, location):
	var enemy = EnemyScene.instance()
	add_child(enemy)
	enemy.global_position = location
	if enemy.has_signal("spawn_laser"):
		enemy.connect("spawn_laser", self, "spawn_laser")
	enemy.connect("enemy_died", self, "_on_enemy_died")

func _on_DeathZone_area_entered(area):
	area.queue_free()

func _on_enemy_died(_score, location):
	update_score_and_hud(score + _score)
	create_explosion(location)

func update_score_and_hud(val):
	score = val
	hud.update_score(score)

func _on_Player_player_took_damage(hp_left):
	hud.update_lives(hp_left)

func _on_Player_player_died(location):
	# Player died, Run the GAME OVER
	create_explosion(location)
	game_over()

func game_over():
	enemy_spawner.stop()
	
	var timer = get_tree().create_timer(3)
	yield(timer, "timeout")
	
	var game_over_menu = GameOver.instance()
	ui_layer.add_child(game_over_menu)
	game_over_menu.set_score(score)

func create_explosion(location):
	# Sets the position of the explosion to the enemy or player,
	# 	It starts an explosion after player or enemy dies.
	explosion_effect.global_position = location
	explosion_effect.start()
