extends Node2D

var players := {}

func play(stream: AudioStream, from: float = 0.0):
	if stream in players:
		var player := players[stream] as AudioStreamPlayer
		if player:
			player.play(from)
	else:
		var player := AudioStreamPlayer.new()
		player.stream = stream
		add_child(player)
		player.play(from)
		player.max_polyphony = 16
		players[stream] = player
