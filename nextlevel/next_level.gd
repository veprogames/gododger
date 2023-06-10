class_name NextLevel
extends Area2D

@export var safe_area: Shape2D

func _ready() -> void:
	var safe_zone = $SafeZone as SafeZone
	if safe_zone:
		safe_zone.trigger()
