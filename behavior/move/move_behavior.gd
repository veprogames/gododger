class_name MoveBehavior
extends Behavior

## Give player time to react by accelerating stuff over 500 ms
func get_speed_mod() -> float:
	return min(elapsed * 2, 1.0)
