class_name KeyCollectible
extends Area2D

@onready var level := $"/root/Level" as Level
@onready var safe_zone := $SafeZone as SafeZone

func _ready() -> void:
	safe_zone.trigger()

func collect() -> void:
	queue_free()
