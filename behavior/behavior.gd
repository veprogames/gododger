class_name Behavior
extends Node

@export var enemy: Enemy
@export var bpm: int = 222
## used in conjunction of stage lvl to calc
## scaling difficulty
@export var level: int

@export var level_instance: Level

var elapsed := 0.0

func _physics_process(delta: float) -> void:
	elapsed += delta

## How many times per second based on bpm
func get_bpm_rate() -> float:
	return bpm / 60.0
