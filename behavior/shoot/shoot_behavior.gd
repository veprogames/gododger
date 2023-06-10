class_name ShootBehavior
extends Behavior

var Bullet := preload("res://bullet/bullet.tscn")
@onready var root := $"/root/Level/Enemies"

func shoot(direction: float, speed: float) -> void:
	var bullet := Bullet.instantiate() as Bullet
	root.add_child(bullet)
	bullet.direction = direction
	bullet.speed = speed
	bullet.position = enemy.position
