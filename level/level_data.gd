class_name LevelData
extends Resource

## amount of total highscore required
@export var requirement: int
@export var id: String
@export var title: String
@export var song: String
@export var background: Texture2D
@export_file("*.tscn") var scene_path: String

func is_unlocked() -> bool:
	return Global.get_total_score() >= requirement
