extends Node2D

@export var environment: WorldEnvironment
@export var camera: Camera2D
@export var bg_particles: GPUParticles2D
var analyzer := AudioServer.get_bus_effect_instance(0, 0) as AudioEffectSpectrumAnalyzerInstance

func _ready() -> void:
	if not analyzer:
		push_warning("Spectrum Analyzer not found!")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if analyzer:
		var intensity := analyzer.get_magnitude_for_frequency_range(20, 20000).length()
		environment.environment.glow_strength = 1.1 + intensity * 0.7
		camera.offset = Vector2(randf_range(-1, 1), randf_range(-1, 1)) * intensity
		bg_particles.speed_scale = 24 * intensity
