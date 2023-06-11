class_name Enemy
extends Area2D

@onready var animation_player := $AnimationPlayer as AnimationPlayer

func play_shoot_animation() -> void:
	animation_player.play("shoot")
