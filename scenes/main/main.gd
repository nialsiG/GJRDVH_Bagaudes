extends Node

@export var initial_contentement: float = 100.0
@export var initial_year: int = 1830
@export var final_year: int = 1831

@onready var title_screen = %TitleScreen
@onready var event_screen: EventScreen = %EventScreen
@onready var year_counter: Label = %YearCounter
@onready var event_manager: EventManager = $EventManager
@onready var music_manager = $MusicManager
@onready var pandemic_ending_screen = $CanvasLayer/GameOver/PandemicEndingScreen
@onready var insurection_ending_screen = $CanvasLayer/GameOver/InsurectionEndingScreen
@onready var victory_screen = $CanvasLayer/GameOver/VictoryScreen

@onready var district_1: District = %District1
@onready var district_2: District = %District2
@onready var district_3: District = %District3
@onready var district_4: District = %District4

@onready var time_texture_progress_bar: TextureProgressBar = %TimeTextureProgressBar
@onready var time_texture_rect: TextureRect = %TimeTextureRect
@onready var contentement_progress_bar: ProgressBar = %ContentementProgressBar

var current_contentement: float
var current_year: int

func _ready():
	LoadTitleScreen()
	SignalManager.AddContentement.connect(AddContentement)
	SignalManager.AddYear.connect(AddYear)

func LoadTitleScreen():
	title_screen.show()
	music_manager.PlayMusic(Enums.Soundtrack.TITLE)

func Init():
	#current_contentement = initial_contentement
	ResetYear()
	ResetContentement()
	ResetPopup()
	pandemic_ending_screen.hide()
	insurection_ending_screen.hide()
	victory_screen.hide()
	# districts
	district_1.Init()
	district_2.Init()
	district_3.Init()
	district_4.Init()
	# initial load of event
	await get_tree().create_timer(0.5).timeout
	event_manager.Init(initial_year) 

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


#region Contentement manager
func ResetContentement():
	current_contentement = initial_contentement
	contentement_progress_bar.min_value = 0.0
	contentement_progress_bar.max_value = 100.0
	contentement_progress_bar.value = current_contentement
	UpdateContentement()

func UpdateContentement():
	contentement_progress_bar.value = current_contentement
	var range = contentement_progress_bar.max_value - contentement_progress_bar.min_value
	if current_contentement >= range / 2:
		contentement_progress_bar.set_modulate(Color.PALE_GREEN)
	elif current_contentement < range / 2 and current_contentement >= range / 4:
		contentement_progress_bar.set_modulate(Color.ORANGE)
	elif current_contentement < range / 4:
		contentement_progress_bar.set_modulate(Color.INDIAN_RED)
	elif current_contentement <= 0:
		SignalManager.RevolutionEnding.emit()

func AddContentement(amount: float):
	current_contentement += amount
	if current_contentement <= 0:
		SignalManager.RevolutionEnding.emit()
	UpdateContentement()
#endregion

#region Time manager
func ResetYear():
	current_year = initial_year
	time_texture_progress_bar.min_value = initial_year
	time_texture_progress_bar.max_value = final_year
	UpdateYear()

func UpdateYear():
	year_counter.text = str(current_year)
	time_texture_progress_bar.value = current_year
	time_texture_rect.position.x = (current_year - initial_year) * (time_texture_progress_bar.texture_under.get_width() / (final_year - initial_year))

func AddYear(amount: float):
	current_year += amount
	#if current_year >= 100:
		#SignalManager.GoodEnding.emit()
		#
	UpdateYear()
	if current_year >= final_year:
		print("VICTORY")
		SignalManager.Victory.emit()
		victory_screen.show()
#endregion 
