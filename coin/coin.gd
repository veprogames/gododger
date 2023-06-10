class_name Coin
extends Area2D

@onready var level := $"/root/Level" as Level

func _ready() -> void:
	$SafeZone.trigger()

func get_value() -> int:
	return 25 * (level.level + 1) ** 2
