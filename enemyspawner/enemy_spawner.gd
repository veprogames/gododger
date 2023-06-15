class_name EnemySpawner
extends Node2D

signal node_spawned(node: Node2D)
signal key_spawned(key: KeyCollectible)

@export var enemy_scene: PackedScene
@export var nextlevel_scene: PackedScene
@export var player: Player
@export var level: Level

var Key := preload("res://key/key.tscn")

var PeriodicMoveBehavior := preload("res://behavior/move/periodic_move_behavior.tscn")
var PeriodicShootBehavior := preload("res://behavior/shoot/periodic_shoot_behavior.tscn")

var viewport: Rect2

func _ready():
	viewport = player.get_camera_rect()

func get_move_chance() -> float:
	return minf(level.level * 0.01 + 0.1, 0.75)

func get_shoot_chance() -> float:
	return minf(level.level * 0.01 + 0.1, 0.75)

func get_behaviors(enemy: Enemy) -> Array[Behavior]:
	var result: Array[Behavior] = []
	if randf() < get_move_chance():
		var move := PeriodicMoveBehavior.instantiate()
		result.push_back(move)
	if randf() < get_shoot_chance():
		var shoot := PeriodicShootBehavior.instantiate()
		result.push_back(shoot)
	for b in result:
		b.level = level.level
		b.enemy = enemy
	return result

func get_random_position(padding: float = 0.0) -> Vector2:
	var pos = Vector2(
		randf_range(padding, viewport.size.x - padding),
		randf_range(padding, viewport.size.y - padding)
	) + viewport.position
	return pos.snapped(Vector2.ONE * 8)

func spawn_enemy():
	var pos := get_random_position()
	var enemy := enemy_scene.instantiate() as Enemy
	if enemy:
		var behaviors := get_behaviors(enemy)
		enemy.position = pos
		for b in behaviors:
			enemy.add_child(b)
		emit_signal("node_spawned", enemy)

func spawn_nextlevel():
	var nextlevel := nextlevel_scene.instantiate() as NextLevel
	if nextlevel:
		nextlevel.position = get_random_position(24)
		emit_signal("node_spawned", nextlevel)

func spawn_key() -> void:
	var key := Key.instantiate() as KeyCollectible
	key.position = get_random_position(8)
	emit_signal("key_spawned", key)

func get_enemy_count() -> int:
	@warning_ignore("integer_division")
	return 6 + clampi(level.level, 0, 20) \
		+ int(clampi(level.level - 20, 0, 100) / 5)

func spawn_level(level_: int):
	@warning_ignore("integer_division")
	var key_count := mini(4 + int(level.level / 10), 8)
	seed(level_)
	for i in range(get_enemy_count()):
		spawn_enemy()
	spawn_nextlevel()
	for i in range(key_count):
		spawn_key()
	player.trigger_safezone.call_deferred()
