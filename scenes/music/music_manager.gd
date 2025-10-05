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

var current_volume = -10.0

func PlayMusic(soundtrack: Enums.Soundtrack):
	FadeOut()
	await get_tree().create_timer(0.6).timeout
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
	var timer = get_tree().create_timer(audio_stream_player.stream.get_length() - 0.5)
	timer.timeout.connect(FadeOutAndChange)

func FadeOutAndChange():
	var fade_out = create_tween()
	fade_out.tween_property(audio_stream_player, "volume_db", -30.0, 0.5)
	fade_out.tween_callback(ChangeMusic)

func ChangeMusic():
	audio_stream_player.stop()
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
	FadeIn()

func FadeIn():
	var fade_in = create_tween()
	fade_in.tween_property(audio_stream_player, "volume_db", current_volume, 0.5)

func FadeOut():
	var fade_out = create_tween()
	fade_out.tween_property(audio_stream_player, "volume_db", -30.0, 0.5)
	fade_out.tween_callback(FadeIn)

#func _on_audio_stream_player_finished():
	#FadeOutAndChange()
	
