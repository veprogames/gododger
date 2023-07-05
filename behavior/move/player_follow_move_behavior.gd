class_name PlayerFollowMoveBehavior
extends MoveBehavior

var direction := 0.0

var rotate_speed: float
var move_speed: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	direction = randf_range(0, TAU)
	move_speed = get_speed()
	rotate_speed = randf_range(1.0, 7.5)

func get_speed() -> float:
	var mult := 1.0 + 0.05 * clampf(level, 0, 50)
	mult *= level_instance.difficulty_multiplier ** 0.5
	return 60 * mult * randf_range(0.75, 1.25)

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	var angle := enemy.position.angle_to_point(get_player_position())
	direction = lerp_angle(direction, angle, rotate_speed * delta)
	enemy.position += Vector2.RIGHT.rotated(direction) * move_speed * get_speed_mod() * delta
