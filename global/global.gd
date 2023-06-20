extends Node2D

var highscores := {}

func _ready() -> void:
	load_game()

func save_highscore(id: String, score: int) -> void:
	highscores[id] = maxi(highscores[id] if id in highscores else 0, score)
	save_game()

func get_highscore(id: String) -> int:
	return highscores.get(id, 0)

func get_total_score() -> int:
	var sum := 0
	for k in highscores:
		if highscores[k] is int:
			sum += highscores[k]
	return sum

func save_game() -> void:
	var f := FileAccess.open_encrypted_with_pass("user://gododger.sav", FileAccess.WRITE, OS.get_unique_id())
	var save_obj := {
		"highscores": highscores
	}
	f.store_pascal_string(var_to_str(save_obj))
	f.close()

func load_game() -> void:
	var f := FileAccess.open_encrypted_with_pass("user://gododger.sav", FileAccess.READ, OS.get_unique_id())
	if f:
		var line = f.get_pascal_string()
		var data = str_to_var(line)
		if data is Dictionary and "highscores" in data:
			highscores = data.highscores
		f.close()
