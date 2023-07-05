class_name EnemySpawner
extends Node2D

signal node_spawned(node: Node2D)
signal key_spawned(key: KeyCollectible)

@export var enemy_scene: PackedScene
@export var nextlevel_scene: PackedScene
@export var player: Player
@export var level: Level

@export_category("Level Configuration")
@export var enemy_sprite: Texture
@export var move_behaviors: Array[PackedScene]
@export var shoot_behaviors: Array[PackedScene]

var base_seed := 0

var Key := preload("res://key/key.tscn")

var viewport: Rect2

func _ready():
	base_seed = get_base_seed()
	viewport = player.get_camera_rect()

func get_base_seed() -> int:
	var s := 0
	var level_id := level.level_data.id
	for c in level_id:
		var ord := c.unicode_at(0)
		s = (s * ord + ord) % 65_536
	return s

func get_move_chance() -> float:
	return minf((level.level * 0.01 + 0.1) * level.difficulty_multiplier, 0.75)

func get_shoot_chance() -> float:
	return minf((level.level * 0.005 + 0.1) * level.difficulty_multiplier, 0.75)

func random_move_behavior() -> MoveBehavior:
	if len(move_behaviors) == 0:
		return null
	return move_behaviors[randi() % len(move_behaviors)].instantiate() as MoveBehavior

func random_shoot_behavior() -> ShootBehavior:
	if len(shoot_behaviors) == 0:
		return null
	return shoot_behaviors[randi() % len(shoot_behaviors)].instantiate() as ShootBehavior

func get_behaviors(enemy: Enemy) -> Array[Behavior]:
	var result: Array[Behavior] = []
	if randf() < get_move_chance():
		var move := random_move_behavior()
		if move:
			result.push_back(move)
	if randf() < get_shoot_chance():
		var shoot := random_shoot_behavior()
		if shoot:
			result.push_back(shoot)
	for b in result:
		b.level_instance = level
		b.player_instance = player
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
		if enemy_sprite:
			enemy.set_texture(enemy_sprite)
		var behaviors := get_behaviors(enemy)
		enemy.position = pos
		for b in behaviors:
			enemy.add_child(b)
			b.bpm = level.get_bpm()
		emit_signal("node_spawned", enemy)

func spawn_nextlevel():
	var nextlevel := nextlevel_scene.instantiate() as NextLevel
	if nextlevel:
		nextlevel.level = level
		nextlevel.position = get_random_position(24)
		emit_signal("node_spawned", nextlevel)

func spawn_key() -> void:
	var key := Key.instantiate() as KeyCollectible
	key.level = level
	key.position = get_random_position(8)
	emit_signal("key_spawned", key)

func get_enemy_count() -> int:
	var level_diff := int(level.level * level.difficulty_multiplier)
	@warning_ignore("integer_division")
	return 6 + clampi(level_diff, 0, 20) \
		+ int(clampi(level_diff - 20, 0, 100) / 5)

func spawn_level(level_: int):
	@warning_ignore("integer_division")
	var key_count := mini(4 + int(level.level / 10), 8)
	seed(level_ + base_seed)
	for i in range(get_enemy_count()):
		spawn_enemy()
	spawn_nextlevel()
	for i in range(key_count):
		spawn_key()
	player.trigger_safezone.call_deferred()
