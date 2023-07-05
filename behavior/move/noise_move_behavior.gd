class_name NoiseMoveBehavior
extends MoveBehavior

var noise := FastNoiseLite.new()

@onready var speed := get_speed()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	noise.frequency = (0.5 + 0.05 * level) * level_instance.difficulty_multiplier ** 0.75 
	noise.seed = randi()

func get_speed() -> float:
	var mult := 1.0 + 0.05 * clampf(level, 0, 50)
	mult *= level_instance.difficulty_multiplier ** 0.5
	return 80 * mult * randf_range(-1, 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	enemy.position += Vector2(
		noise.get_noise_1d(elapsed),
		noise.get_noise_1d(elapsed + 1000.0)
	) * delta * speed * get_speed_mod()
