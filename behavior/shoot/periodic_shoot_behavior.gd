class_name PeriodicShootBehavior
extends ShootBehavior

@onready var timer = $Timer as Timer

var count := 1
var rotate_speed := 0.0
var bullet_speed := 100.0
var offset := randf() * TAU
var speed := 1.0

func _ready() -> void:
	var diff := level_instance.difficulty_multiplier ** 0.5
	@warning_ignore("integer_division")
	count = randi_range(1, mini(int(level / 30 * diff + 1), 5))
	speed = 2.0 if randf() < level * 0.01 * diff else 1.0
	bullet_speed = 75.0 + 0.5 * level
	rotate_speed = randf_range(-PI / 10, PI / 10) * (1 + 0.2 * level) * diff
	
	timer.wait_time = 2 / (get_bpm_rate() * speed)

func shoot_pattern() -> void:
	enemy.play_shoot_animation()
	play_audio()
	for i in range(count):
		var a := i / (count as float) * TAU
		shoot(a + offset + rotate_speed * elapsed, bullet_speed)

func _on_timer_timeout() -> void:
	shoot_pattern()
