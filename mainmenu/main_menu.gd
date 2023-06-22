extends Node2D

@onready var label_totalscore := $CanvasLayer/LabelTotalScore as Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	label_totalscore.text = "TotalScore: %d" % Global.get_total_score()
