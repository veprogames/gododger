class_name Bullet
extends Area2D

@export_range(0, TAU) var direction := 0.0
@export var speed := 0.0

func _physics_process(delta: float) -> void:
	position += Vector2.RIGHT.rotated(direction) * speed * delta
	rotation = direction + PI / 2

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
