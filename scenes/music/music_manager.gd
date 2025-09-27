extends Node
class_name MusicManager

@export_group("Music")
@export_file("*mp3") var title_music: String
@export_file("*mp3") var title_music_with_intro: String
@export_file("*mp3") var main_music: String
@export_file("*mp3") var main_music_with_intro: String

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var title_audiostream: AudioStream
var title_with_intro_audiostream: AudioStream
var main_music_audiostream: AudioStream
var main_music_with_intro_audiostream: AudioStream

func _ready():
	title_audiostream = load(title_music)
	title_with_intro_audiostream = load(title_music_with_intro)

func PlayMusic(soundtrack: Enums.Soundtrack):
	match soundtrack:
		Enums.Soundtrack.TITLE:
			audio_stream_player.stream = title_with_intro_audiostream
		Enums.Soundtrack.MAIN:
			audio_stream_player.stream = main_music_with_intro_audiostream
	audio_stream_player.play()


func _on_audio_stream_player_finished():
	if audio_stream_player.stream == title_with_intro_audiostream:
		audio_stream_player.stream = title_audiostream
		audio_stream_player.play()
	if audio_stream_player.stream == main_music_with_intro_audiostream:
		audio_stream_player.stream = main_music_audiostream
		audio_stream_player.play()
