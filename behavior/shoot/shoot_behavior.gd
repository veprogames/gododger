class_name ShootBehavior
extends Behavior

var Bullet := preload("res://bullet/bullet.tscn")
@onready var root := level_instance.find_child("Objects") as Node2D

@onready var sound_shoot := preload("res://behavior/shoot/shoot.wav")

func shoot(direction: float, speed: float) -> void:
	var bullet := Bullet.instantiate() as Bullet
	root.add_child(bullet)
	bullet.direction = direction
	bullet.speed = speed
	bullet.position = enemy.position

func play_audio() -> void:
	GlobalSound.play(sound_shoot)
