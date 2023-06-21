extends CanvasLayer

@export var level: Level
@onready var label_level := $LabelLevel as Label
@onready var label_timer := $LabelTimer as Label
@onready var label_score := $LabelScore as Label
@onready var label_song := $LabelSong as Label
@onready var label_highscore := $HBoxContainer/LabelHighscore as Label

func _ready() -> void:
	update_highscore(Global.get_highscore(level.get_id()))
	label_level.text = "%02d" % (level.level + 1)
	label_song.text = "%s\n%s" % [level.level_data.song, label_song.text]
	level.connect("level_changed", _on_level_changed)
	
	var tween := create_tween()
	tween.tween_property(label_song, "modulate", Color.TRANSPARENT, 15)

func _process(_delta: float) -> void:
	label_timer.text = "%.3f" % level.elapsed
	label_score.text = "%05d" % level.get_score()

func _on_level_changed(current_level: int) -> void:
	label_level.text = "%02d" % (current_level + 1)

func update_highscore(highscore: int) -> void:
	label_highscore.text = "%05d" % highscore
