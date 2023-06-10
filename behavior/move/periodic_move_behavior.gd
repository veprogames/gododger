class_name PeriodicMoveBehavior
extends MoveBehavior

var amplitude := Vector2.ZERO

func _ready() -> void:
	amplitude = get_amplitude()

func get_amplitude() -> Vector2:
	var mult := 1.0 + 0.05 * clampf(level, 0, 50)
	return 50 * mult * Vector2(
		randf_range(-1, 1),
		randf_range(-1, 1)
	)

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	var t = elapsed * TAU / 2.0 * get_bpm_rate()
	enemy.position += delta * get_speed_mod() * Vector2(
		cos(t) * amplitude.x,
		sin(t) * amplitude.y,
	)
