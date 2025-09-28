extends Node
class_name MusicManager

@export_group("Music")
@export var title: AudioStream
@export var title_loop: AudioStream
@export var main: AudioStream
@export var main_loop: AudioStream
@export var victory: AudioStream
@export var victory_loop: AudioStream
@export var cholera: AudioStream
@export var cholera_loop: AudioStream
@export var revolte: AudioStream
@export var revolte_loop: AudioStream

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func PlayMusic(soundtrack: Enums.Soundtrack):
	audio_stream_player.stop()
	match soundtrack:
		Enums.Soundtrack.TITLE:
			audio_stream_player.stream = title
		Enums.Soundtrack.MAIN:
			audio_stream_player.stream = main
		Enums.Soundtrack.VICTORY:
			audio_stream_player.stream = victory
		Enums.Soundtrack.CHOLERA:
			audio_stream_player.stream = cholera
		Enums.Soundtrack.REVOLTE:
			audio_stream_player.stream = revolte
	audio_stream_player.play()


func _on_audio_stream_player_finished():
	match audio_stream_player.stream:
		title:
			audio_stream_player.stream = title_loop
		main:
			audio_stream_player.stream = main_loop
		victory:
			audio_stream_player.stream = victory_loop
		cholera:
			audio_stream_player.stream = cholera_loop
		revolte:
			audio_stream_player.stream = revolte_loop
	audio_stream_player.play()
