extends Control

@export var data: LevelData

@onready var label_title := $HBoxContainer/LabelTitle as Label
@onready var label_requirement := $HBoxContainer/LabelRequirement as Label
@onready var button_play := $HBoxContainer/ButtonPlay as Button

func _ready() -> void:
	label_title.text = "%s\n%s" % [data.title, data.song]
	label_requirement.text = "need: %d" % data.requirement
	button_play.visible = data.is_unlocked()
	label_requirement.visible = !button_play.visible

func play() -> void:
	if data.is_unlocked():
		get_tree().change_scene_to_file(data.scene_path)

func _on_button_play_pressed() -> void:
	play()
