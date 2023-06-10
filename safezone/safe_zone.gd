class_name SafeZone
extends Node2D

@export var shape: Shape2D

func trigger() -> void:
	var state = get_world_2d().direct_space_state
	var query := PhysicsShapeQueryParameters2D.new()
	query.shape = shape
	query.transform = get_global_transform()
	query.collide_with_areas = true
	query.collide_with_bodies = false
	var results = state.intersect_shape(query, 256)
	for result in results:
		var enemy := result.collider as Enemy
		if enemy:
			enemy.queue_free()
