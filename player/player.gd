class_name Player
extends Area2D

signal finished()
signal died()

@export var camera: Camera2D

@onready var sprite: Sprite2D = $Sprite2D

var viewport: Rect2

func _ready() -> void:
	viewport = get_camera_rect()

func get_camera_rect() -> Rect2:
	var viewport_rect := get_viewport_rect()
	var viewport_transform := get_viewport_transform()
	viewport_rect.size /= viewport_transform.x.x
	viewport_rect.position -= viewport_transform.origin / viewport_transform.x.x
	return viewport_rect

func update_sprite(relative: Vector2) -> void:
	var dir := relative.angle()
	var vel := relative.length()
	var scale_factor := 1 + 0.02 * vel
	sprite.rotation = dir
	sprite.scale.x = scale_factor
	sprite.scale.y = 1 / scale_factor

func _input(event):
	var mouse_event := event as InputEventMouseMotion
	var factor := camera.zoom.x
	if mouse_event:
		position.x += mouse_event.relative.x / factor
		position.y += mouse_event.relative.y / factor
		position = position.clamp(
			viewport.position,
			viewport.position + viewport.size
		)
		update_sprite(mouse_event.relative)

func _on_area_entered(area):
	var enemy := area as Enemy
	var next_level := area as NextLevel
	if enemy:
		emit_signal("died")
	if next_level:
		emit_signal("finished")
