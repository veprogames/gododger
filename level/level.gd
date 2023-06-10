class_name Level
extends Node2D

signal level_changed(level: int)

@export var spawner: EnemySpawner
@export var enemy_container: Node2D

@export var level := 0
var elapsed := 0.0
var additional_score := 0

@onready var container_coins := $Coins

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
	for coin in container_coins.get_children():
		coin.queue_free()
	spawner.spawn_level(level)

func get_score() -> int:
	var time_per_level := elapsed / (level + 1)
	return int(1000 * level ** 2 / time_per_level) + additional_score

func _on_player_finished() -> void:
	if container_coins.get_child_count() == 0:
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


func _on_player_coin_collected(coin: Coin) -> void:
	additional_score += coin.get_value()
	coin.queue_free()


func _on_enemy_spawner_coin_spawned(coin) -> void:
	container_coins.add_child.call_deferred(coin)
