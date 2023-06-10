class_name KeyCollectible
extends Area2D

@onready var level := $"/root/Level" as Level
@onready var safe_zone := $SafeZone as SafeZone

func _ready() -> void:
	safe_zone.trigger()

func get_value() -> int:
	return 25 * (level.level + 1) ** 2

func collect() -> void:
	queue_free()
