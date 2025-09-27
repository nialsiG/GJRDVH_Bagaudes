extends Node
class_name SoundManager

@export_group("Sounds")
@export_file("*mp3") var angry_crowd_1: String
@export_file("*mp3") var angry_crowd_2: String
@export_file("*mp3") var angry_crowd_3: String
@export_file("*mp3") var cough_1: String
@export_file("*mp3") var cough_2: String
@export_file("*mp3") var cough_3: String
@export_file("*mp3") var popup_1: String
@export_file("*mp3") var popup_2: String
@export_file("*mp3") var click_validate: String
@export_file("*mp3") var ui_selection_ingame: String
@export_file("*mp3") var ui_selection_titlescreen: String

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var angry_crowd_1_audiostream: AudioStream
var angry_crowd_2_audiostream: AudioStream
var angry_crowd_3_audiostream: AudioStream
var cough_1_audiostream: AudioStream
var cough_2_audiostream: AudioStream
var cough_3_audiostream: AudioStream
var popup_1_audiostream: AudioStream
var popup_2_audiostream: AudioStream
var click_validate_audiostream: AudioStream
var ui_select_ingame_audiostream: AudioStream
var ui_select_titlescreen_audiostream: AudioStream

func _ready():
	angry_crowd_1_audiostream = load(angry_crowd_1)
	angry_crowd_2_audiostream = load(angry_crowd_2)
	angry_crowd_3_audiostream = load(angry_crowd_3)
	cough_1_audiostream = load(cough_1)
	cough_2_audiostream = load(cough_2)
	cough_3_audiostream = load(cough_3)
	popup_1_audiostream = load(popup_1)
	popup_2_audiostream = load(popup_2)
	click_validate_audiostream = load(click_validate)
	ui_select_ingame_audiostream = load(ui_selection_ingame)
	ui_select_titlescreen_audiostream = load(ui_selection_titlescreen)

func PlaySound(sound: Enums.Sound):
	match sound:
		Enums.Sound.CROWD:
			audio_stream_player.stream = angry_crowd_1_audiostream
		Enums.Sound.SELECT_TITLESCREEN:
			audio_stream_player.stream = ui_select_titlescreen_audiostream
	audio_stream_player.play()
