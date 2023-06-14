class_name KeyCollectible
extends Area2D

@onready var level := $"/root/Level" as Level
@onready var safe_zone := $SafeZone as SafeZone
@onready var animation_player := $AnimationPlayer as AnimationPlayer

var collected := false

func _ready() -> void:
	safe_zone.trigger()

func collect() -> void:
	if not collected:
		collected = true
		animation_player.play("collect")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "collect":
		queue_free()
