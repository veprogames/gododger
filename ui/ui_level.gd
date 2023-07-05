extends Control

@export var data: LevelData

@onready var container_unlocked := $Unlocked as HBoxContainer
@onready var container_locked := $Locked as HBoxContainer

@onready var label_title := $Unlocked/Control/LabelTitle as Label
@onready var label_song := $Unlocked/Control/LabelSong as Label
@onready var label_requirement := $Locked/Control/LabelRequirement as Label
@onready var image_level := $Unlocked/Container/PreviewClip/LevelImage as TextureRect
@onready var button_play := $Unlocked/Control/ButtonPlay as Button
@onready var particles_level20 := $GPUParticlesLevel20 as GPUParticles2D
@onready var particles_level40 := $GPUParticlesLevel40 as GPUParticles2D

func _ready() -> void:
	label_title.text = data.title
	label_song.text = data.song
	label_requirement.text = "need: %d" % data.requirement
	label_requirement.visible = !button_play.visible
	image_level.texture = data.background
	
	var highscore_level := Global.get_highscore_level(data.id)
	if highscore_level < 20:
		particles_level20.queue_free()
	if highscore_level < 40:
		particles_level40.queue_free()

	if data.is_unlocked():
		container_locked.queue_free()
	else:
		container_unlocked.queue_free()

func play() -> void:
	if data.is_unlocked():
		get_tree().change_scene_to_file(data.scene_path)

func _on_button_play_pressed() -> void:
	play()
