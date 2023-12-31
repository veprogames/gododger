class_name NextLevel
extends Area2D

@export var level: Level
@onready var sprite := $Sprite2D as Sprite2D
@onready var particles := $GPUParticles2D as GPUParticles2D

@onready var texture_enabled := preload("res://nextlevel/portal_enabled.png")

@onready var sound_next := preload("res://nextlevel/open.wav")

var active := false

func _ready() -> void:
	var safe_zone = $SafeZone as SafeZone
	if safe_zone:
		safe_zone.trigger()
	if level:
		level.everything_collected.connect(activate)

func activate() -> void:
	active = true
	GlobalSound.play(sound_next)
	sprite.texture = texture_enabled
	particles.emitting = true
