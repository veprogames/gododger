class_name NextLevel
extends Area2D

@onready var level := $"/root/Level" as Level
@onready var sprite := $Sprite2D as Sprite2D
@onready var particles := $GPUParticles2D as GPUParticles2D
@onready var audio_open := $AudioOpen as AudioStreamPlayer

@onready var texture_enabled := preload("res://nextlevel/portal_enabled.png")

var active := false

func _ready() -> void:
	var safe_zone = $SafeZone as SafeZone
	if safe_zone:
		safe_zone.trigger()
	if level:
		level.everything_collected.connect(activate)

func activate() -> void:
	active = true
	audio_open.play()
	sprite.texture = texture_enabled
	particles.emitting = true
