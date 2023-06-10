class_name Behavior
extends Node

@export var enemy: Enemy
@export var bpm: int = 128
## used in conjunction of stage lvl to calc
## scaling difficulty
@export var level: int

var elapsed := 0.0

func _physics_process(delta: float) -> void:
	elapsed += delta

## How many times per second based on bpm
func get_bpm_rate() -> float:
	return 60.0 / bpm
