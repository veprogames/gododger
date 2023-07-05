extends Node2D

@onready var label_totalscore := $CanvasLayer/LabelTotalScore as Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	label_totalscore.text = "TotalScore: %d" % Global.get_total_score()

func _input(event: InputEvent) -> void:
	var key_event := event as InputEventKey
	if key_event and key_event.keycode == KEY_ESCAPE:
		get_tree().quit()

func _on_button_quit_pressed() -> void:
	get_tree().quit()
