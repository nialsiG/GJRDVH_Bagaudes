extends Node

@export var initial_contentement: float = 100.0
@export var initial_year: int = 1830
@export var final_year: int = 1831

@onready var title_screen = %TitleScreen
@onready var event_screen: EventScreen = %EventScreen
@onready var year_counter: Label = %YearCounter
@onready var event_manager: EventManager = $EventManager
@onready var music_manager: MusicManager = $MusicManager
@onready var pandemic_ending_screen = $CanvasLayer/GameOver/PandemicEndingScreen
@onready var insurection_ending_screen = $CanvasLayer/GameOver/InsurectionEndingScreen
@onready var victory_screen = $CanvasLayer/GameOver/VictoryScreen

@onready var district_1: District = %District1
@onready var district_2: District = %District2
@onready var district_3: District = %District3
@onready var district_4: District = %District4

@onready var time_texture_progress_bar: TextureProgressBar = %TimeTextureProgressBar
@onready var time_texture_rect: TextureRect = %TimeTextureRect
@onready var timer_h_slider = %TimerHSlider

@onready var contentement_progress_bar: TextureProgressBar = %ContentementProgressBar
@onready var tutorial_screen: TextureRect = $CanvasLayer/TutorialScreen

var current_contentement: float
var current_year: int

func _ready():
	LoadTitleScreen()
	SignalManager.AddContentement.connect(AddContentement)
	SignalManager.AddYear.connect(AddYear)
	SignalManager.EpidemicEnding.connect(music_manager.PlayMusic.bind(Enums.Soundtrack.CHOLERA))
	SignalManager.CheckGameOver.connect(CheckGameOver)

func LoadTitleScreen():
	title_screen.show()
	title_screen.Reset()
	music_manager.PlayMusic(Enums.Soundtrack.TITLE)

func Init():
	#current_contentement = initial_contentement
	ResetPopup()
	ResetYear()
	ResetContentement()
	pandemic_ending_screen.hide()
	insurection_ending_screen.hide()
	victory_screen.hide()
	title_screen.Reset()
	# districts
	district_1.Init()
	district_2.Init()
	district_3.Init()
	district_4.Init()
	# initial load of event
	event_screen.Reset()
	event_manager.Init(initial_year) 
	tutorial_screen.visible=true

func ResetPopup():
	for popup in get_tree().get_nodes_in_group("popup"):
		popup.queue_free()

#func _input(event):
		#if event is InputEventKey and event.pressed and event.keycode == KEY_SPACE:
			#SignalManager.spawn_popup_requested.emit()
			#
			
#func TriggerNewEvent():
	#event_manager.SelectRandomEvent()

func _on_start_button_pressed():
	SignalManager.PlaySound.emit(Enums.Sound.SELECT_TITLESCREEN)
	music_manager.PlayMusic(Enums.Soundtrack.MAIN)
	Init()
	title_screen.hide()

func _on_back_to_title_button_pressed():
	SignalManager.PlaySound.emit(Enums.Sound.SELECT_INGAME)
	music_manager.PlayMusic(Enums.Soundtrack.TITLE)
	title_screen.show()

func _on_hide_tuto_button_pressed() -> void:
		SignalManager.PlaySound.emit(Enums.Sound.VALIDATE)
		tutorial_screen.visible=false


#region Contentement manager
func ResetContentement():
	current_contentement = initial_contentement
	contentement_progress_bar.min_value = 0.0
	contentement_progress_bar.max_value = 100.0
	contentement_progress_bar.value = current_contentement
	UpdateContentement()

func UpdateContentement():
	#print("update contentement...")
	var tween = create_tween()
	tween.tween_property(contentement_progress_bar, "value", current_contentement, 1.0)
	#contentement_progress_bar.value = current_contentement
	var range = contentement_progress_bar.max_value - contentement_progress_bar.min_value

func AddContentement(amount: float):
	current_contentement += amount
	UpdateContentement()
#endregion

#region Time manager
func ResetYear():
	current_year = initial_year
	time_texture_progress_bar.min_value = initial_year
	time_texture_progress_bar.max_value = final_year
	UpdateYear()

func UpdateYear():
	year_counter.text = str("An ", current_year)
	var tween = create_tween()
	tween.tween_property(time_texture_progress_bar, "value", current_year, 1.0)
	var destination = (current_year - initial_year) * (time_texture_progress_bar.texture_under.get_width() - 10) / (final_year - initial_year) - 50
	var tween2 = create_tween()
	tween2.tween_property(time_texture_rect, "position", Vector2(destination, time_texture_rect.position.y), 1.0)

func AddYear(amount: float):
	current_year += amount
	#if current_year >= 100:
		#SignalManager.GoodEnding.emit()
		#
	UpdateYear()
#endregion 

func CheckGameOver():
	if current_contentement <= 0:
		SignalManager.RevolutionEnding.emit()
		music_manager.PlayMusic(Enums.Soundtrack.REVOLTE)
	elif current_year >= final_year:
		SignalManager.GoodEnding.emit()
		music_manager.PlayMusic(Enums.Soundtrack.VICTORY)
		victory_screen.show()

func _on_option_button_toggled(toggled_on):
	SignalManager.PlaySound.emit(Enums.Sound.VALIDATE)
	event_screen.help_to_decision = toggled_on
