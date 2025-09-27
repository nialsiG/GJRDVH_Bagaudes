extends Node

@export var initial_contentement: float = 1.0
@export var initial_year: int = 1830
@export var final_year: int = 1831

@onready var title_screen = %TitleScreen
@onready var event_screen: EventScreen = %EventScreen
@onready var year_counter: Label = %YearCounter
@onready var event_manager: EventManager = $EventManager
@onready var music_manager = $MusicManager

@onready var district_1: District = %District1
@onready var district_2: District = %District2
@onready var district_3: District = %District3
@onready var district_4: District = %District4

@onready var time_texture_progress_bar: TextureProgressBar = %TimeTextureProgressBar
@onready var time_texture_rect: TextureRect = %TimeTextureRect

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
	current_contentement = initial_contentement
	ResetYear()
	# districts
	district_1.Init()
	district_2.Init()
	district_3.Init()
	district_4.Init()
	# initial load of event
	event_manager.Init() 

func _input(event):
		if event is InputEventKey and event.pressed and event.keycode == KEY_SPACE:
			SignalManager.spawn_popup_requested.emit()
			
func TriggerNewEvent():
	event_manager.SelectRandomEvent()

func _on_start_button_pressed():
	Init()
	title_screen.hide()

func AddContentement(amount: float):
	current_contentement += amount
	print("contentement: ", current_contentement)

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
	UpdateYear()
	if current_year >= final_year:
		print("VICTORY")
		SignalManager.Victory.emit()
#endregion 
