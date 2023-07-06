extends Node2D

const VERSION := 1

var highscores := {}

func _ready() -> void:
	load_game()

func submit_stats(id: String, score: int, level: int) -> void:
	if id in highscores:
		highscores[id].score = maxi(highscores[id].score, score)
		highscores[id].level = maxi(highscores[id].level, level)
	else:
		highscores[id] = {
			"score": score,
			"level": level,
		}
	save_game()

func get_highscore(id: String) -> int:
	if id in highscores:
		return highscores[id].get("score", 0)
	return 0

func get_highscore_level(id: String) -> int:
	if id in highscores:
		return highscores[id].get("level", 0)
	return 0

func get_total_score() -> int:
	var sum := 0
	for k in highscores:
		if "score" in highscores[k] and highscores[k].score is int:
			sum += highscores[k].score
	return sum

func migrate_save(old_save: Dictionary) -> Dictionary:
	var version := old_save.version as int if "version" in old_save else 0
	if version < 1:
		for id in old_save.highscores:
			old_save.highscores[id] = {
				"score": old_save.highscores[id],
				"level": 0,
			}
	return old_save

func save_game() -> void:
	var f := FileAccess.open_encrypted_with_pass("user://gododger.sav", FileAccess.WRITE, OS.get_unique_id())
	var save_obj := {
		"version": VERSION,
		"highscores": highscores,
	}
	f.store_pascal_string(var_to_str(save_obj))
	f.close()

func load_game() -> void:
	var f := FileAccess.open_encrypted_with_pass("user://gododger.sav", FileAccess.READ, OS.get_unique_id())
	if f:
		var line = f.get_pascal_string()
		var data = str_to_var(line)
		data = migrate_save(data)
		if data is Dictionary and "highscores" in data:
			highscores = data.highscores
		f.close()
