extends Area2D
class_name Player

signal spawn_laser(Laser, location)
signal player_took_damage(hp_left)
signal player_died(location)

export (int) var speed = 300
export (int) var hp = 5
export (int) var damage = 1

var input_vector = Vector2.ZERO

var Laser = preload("res://projectiles/PlayerLaser.tscn")

onready var muzzle = $Muzzle
onready var hit_sound = $HitSound
onready var laser_sound = $LaserSound

func _physics_process(delta):
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	global_position.x += input_vector.x * speed * delta
	global_position.y += input_vector.y * speed * delta
	
	global_position.x = clamp(global_position.x, 0, 540)
	global_position.y = clamp(global_position.y, 0, 960)
	
	if Input.is_action_just_pressed("shoot"):
		emit_signal("spawn_laser", Laser, muzzle.global_position)
		laser_sound.play()


func _on_Player_area_entered(area):
	if area.is_in_group("enemies"):
		area.take_damage(damage)

func take_damage(_damage):
	hp -= _damage
	hit_sound.play()
	emit_signal("player_took_damage", hp)
	if hp <= 0:
		queue_free()
		emit_signal("player_died", global_position)
