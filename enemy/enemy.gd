class_name Enemy
extends Area2D

@export var texture := preload("res://enemy/enemy.png")

@onready var animation_player := $AnimationPlayer as AnimationPlayer
@onready var sprite := $Sprite as Sprite2D

func _ready() -> void:
	sprite.texture = texture

func play_shoot_animation() -> void:
	animation_player.play("shoot")

func set_texture(tex: Texture2D) -> void:
	texture = tex
