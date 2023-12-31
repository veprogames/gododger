class_name Level
extends Node2D

signal level_changed(level: int)
signal everything_collected()
signal game_restarted(highscore: int)

@export var level := 0
@export var level_data: LevelData
var elapsed := 0.0
var score_multiplier := 1.0
var highscore := 0

@export_category("Level Configuration")
@export var difficulty_multiplier := 1.0

@onready var spawner := $EnemySpawner as EnemySpawner
@onready var music_player := $MusicPlayer as AudioStreamPlayer
@onready var container_objects := $Objects
@onready var container_keys := $Keys
@onready var timer_restart := $TimerRestart as Timer
@onready var level_background := $CanvasLayer/LevelBackground as TextureRect

var keys_left: Array[KeyCollectible] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	spawner.spawn_level(level)
	level_background.texture = level_data.background

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	elapsed += delta

func get_id() -> String:
	return level_data.id

func spawn_current_level() -> void:
	for enemy in container_objects.get_children():
		enemy.queue_free()
	for key in container_keys.get_children():
		key.queue_free()
	spawner.spawn_level(level)

func get_score() -> int:
	var time_per_level := elapsed / (level + 1)
	var difficulty_modifier := difficulty_multiplier ** 2.0
	return int(100 * level ** 1.15 / time_per_level * score_multiplier * difficulty_modifier)

func _on_player_finished() -> void:
	level += 1
	keys_left = []
	emit_signal("level_changed", level)
	spawn_current_level()

func _on_enemy_spawner_node_spawned(node) -> void:
	container_objects.add_child.call_deferred(node)


func _on_player_died(death_instance: PlayerDeath) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	Global.submit_stats(get_id(), get_score(), level)
	game_restarted.emit(highscore)
	add_child(death_instance)
	var tween := create_tween()
	tween.tween_property(music_player, "pitch_scale", 0.01, 1.5) \
		.set_ease(Tween.EASE_IN_OUT) \
		.set_trans(Tween.TRANS_CUBIC)
	timer_restart.start()

func _on_enemy_spawner_key_spawned(key) -> void:
	container_keys.add_child.call_deferred(key)
	keys_left.push_back(key)


func _on_player_key_collected(key: KeyCollectible) -> void:
	score_multiplier += 0.04
	keys_left.erase(key)
	if len(keys_left) == 0:
		everything_collected.emit()

func get_bpm() -> int:
	var stream = music_player.stream as AudioStreamOggVorbis
	return stream.bpm if stream else 1

func _input(event: InputEvent) -> void:
	var ev := event as InputEventKey
	if ev and ev.pressed and ev.keycode == KEY_ESCAPE:
		Global.submit_stats(get_id(), get_score(), level)
		get_tree().change_scene_to_file("res://mainmenu/main_menu.tscn")


func _on_timer_restart_timeout() -> void:
	get_tree().reload_current_scene()
