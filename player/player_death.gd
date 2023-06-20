class_name PlayerDeath
extends GPUParticles2D

@onready var timer := $Timer as Timer

func _ready() -> void:
	emitting = true
	await timer.timeout
	queue_free()
