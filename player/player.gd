class_name Player
extends Area2D

signal finished()
signal died()
signal key_collected(key: KeyCollectible)

@export var camera: Camera2D

@onready var sprite := $Sprite2D as Sprite2D
@onready var safe_zone := $SafeZone as SafeZone

var viewport: Rect2

var last_times: Array[float] = []
var last_positions: Array[Vector2] = []

func _ready() -> void:
	viewport = get_camera_rect()
	trigger_safezone()

func _process(delta: float) -> void:
	last_positions.push_front(position)
	for i in range(len(last_times)):
		last_times[i] += delta
	last_times.push_front(0.0)
	if last_times[len(last_times) - 1] > 0.1:
		last_positions.pop_back()
		last_times.pop_back()
	# get move speed over last frames
	var move_delta := get_speed_over_time(last_positions)
	update_sprite(move_delta)

func get_speed_over_time(positions: Array[Vector2]) -> Vector2:
	if len(positions) < 2:
		return Vector2.ZERO
	return positions[0] - positions[len(positions) - 1]

func trigger_safezone() -> void:
	safe_zone.trigger()

func get_camera_rect() -> Rect2:
	var origin := camera.get_screen_center_position()
	var size := camera.get_viewport_rect().size / camera.zoom
	return Rect2(Vector2(origin - size / 2.0), size)

func update_sprite(relative: Vector2) -> void:
	var dir := relative.angle()
	var vel := relative.length()
	var scale_factor := 1 + 0.02 * vel
	scale_factor = minf(2, scale_factor)
	sprite.rotation = dir
	sprite.scale.x = scale_factor
	sprite.scale.y = 1 / scale_factor

func _input(event: InputEvent) -> void:
	var mouse_event := event as InputEventMouseMotion
	var factor := camera.zoom.x
	if mouse_event:
		position.x += mouse_event.relative.x / factor
		position.y += mouse_event.relative.y / factor
		position = position.clamp(
			viewport.position,
			viewport.position + viewport.size
		)

func _on_area_entered(area: Area2D):
	if area is Enemy or area is Bullet:
		emit_signal("died")
	if area is KeyCollectible:
		var key = area as KeyCollectible
		emit_signal("key_collected", key)
		key.collect()
	if area is NextLevel and (area as NextLevel).active:
		emit_signal("finished")
