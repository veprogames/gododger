class_name Player
extends Area2D

signal finished()
signal died()
signal key_collected(key: KeyCollectible)

@export var camera: Camera2D

@onready var sprite := $Sprite2D as Sprite2D
@onready var safe_zone := $SafeZone as SafeZone

var viewport: Rect2

var last_input_move := Vector2.ZERO

func _ready() -> void:
	viewport = get_camera_rect()
	trigger_safezone()

func _process(_delta: float) -> void:
	update_sprite(last_input_move)

func trigger_safezone() -> void:
	safe_zone.trigger()

func get_camera_rect() -> Rect2:
	var origin := camera.get_screen_center_position()
	var size := camera.get_viewport_rect().size / camera.zoom
	return Rect2(Vector2(origin - size / 2.0), size)

func update_sprite(relative: Vector2) -> void:
	var dir := relative.angle()
	var vel := relative.length()
	var scale_factor := 1 + 0.05 * vel
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
		last_input_move = mouse_event.relative

func _on_area_entered(area: Area2D):
	if area is Enemy or area is Bullet:
		emit_signal("died")
	if area is KeyCollectible:
		var key = area as KeyCollectible
		emit_signal("key_collected", key)
		key.collect()
	if area is NextLevel and (area as NextLevel).active:
		emit_signal("finished")
