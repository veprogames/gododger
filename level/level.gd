class_name Level
extends Node2D

signal level_changed(level: int)
signal everything_collected()

@export var level := 0
var elapsed := 0.0
var score_multiplier := 1.0

@onready var spawner := $EnemySpawner as EnemySpawner
@onready var container_objects := $Objects
@onready var container_keys := $Keys

var keys_left: Array[KeyCollectible] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	spawner.spawn_level(level)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	elapsed += delta

func spawn_current_level() -> void:
	for enemy in container_objects.get_children():
		enemy.queue_free()
	for key in container_keys.get_children():
		key.queue_free()
	spawner.spawn_level(level)

func get_score() -> int:
	var time_per_level := elapsed / (level + 1)
	return int(10 * level ** 2 / time_per_level * score_multiplier)

func _on_player_finished() -> void:
	level += 1
	keys_left = []
	emit_signal("level_changed", level)
	spawn_current_level()

func _on_enemy_spawner_node_spawned(node) -> void:
	container_objects.add_child.call_deferred(node)


func _on_player_died() -> void:
	level = 0
	elapsed = 0
	score_multiplier = 1.0
	keys_left = []
	emit_signal("level_changed", level)
	spawn_current_level()

func _on_enemy_spawner_key_spawned(key) -> void:
	container_keys.add_child.call_deferred(key)
	keys_left.push_back(key)


func _on_player_key_collected(key: KeyCollectible) -> void:
	score_multiplier += 0.04
	keys_left.erase(key)
	if len(keys_left) == 0:
		everything_collected.emit()
