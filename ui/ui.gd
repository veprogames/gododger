extends CanvasLayer

@export var level: Level
@onready var label_level := $LabelLevel as Label
@onready var label_timer := $LabelTimer as Label
@onready var label_score := $LabelScore as Label
@onready var label_highscore := $HBoxContainer/LabelHighscore as Label

func _ready() -> void:
	update_highscore(0)
	label_level.text = "%02d" % (level.level + 1)
	level.connect("level_changed", _on_level_changed)
	level.game_restarted.connect(update_highscore)

func _process(_delta: float) -> void:
	label_timer.text = "%.3f" % level.elapsed
	label_score.text = "%05d" % level.get_score()

func _on_level_changed(current_level: int) -> void:
	label_level.text = "%02d" % (current_level + 1)

func update_highscore(highscore: int) -> void:
	label_highscore.text = "%05d" % highscore
