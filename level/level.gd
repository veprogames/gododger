class_name Level
extends Node2D

signal level_changed(level: int)

@export var spawner: EnemySpawner
@export var enemy_container: Node2D

@export var level := 0
var elapsed := 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	spawner.spawn_level(level)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	elapsed += delta

func spawn_current_level() -> void:
	for enemy in enemy_container.get_children():
		enemy.queue_free()
	spawner.spawn_level(level)

func get_score() -> int:
	var time_per_level := elapsed / (level + 1)
	return int(1000 * level ** 2 / time_per_level)

func _on_player_finished() -> void:
	level += 1
	emit_signal("level_changed", level)
	spawn_current_level()

func _on_enemy_spawner_node_spawned(node) -> void:
	enemy_container.add_child.call_deferred(node)


func _on_player_died() -> void:
	level = 0
	elapsed = 0
	emit_signal("level_changed", level)
	spawn_current_level()
