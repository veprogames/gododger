class_name NextLevel
extends Area2D

@export var safe_area: Shape2D

func _ready() -> void:
	clear_nearby_enemies()

func clear_nearby_enemies() -> void:
	var state = get_world_2d().direct_space_state
	var query := PhysicsShapeQueryParameters2D.new()
	query.shape = safe_area
	query.transform = get_transform()
	query.collide_with_areas = true
	var results = state.intersect_shape(query, 256)
	for result in results:
		var enemy := result.collider as Enemy
		if enemy:
			enemy.queue_free()
