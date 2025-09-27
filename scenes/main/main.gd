extends Node

@export var initial_contentement: float = 1.0

@onready var title_screen = %TitleScreen
@onready var event_screen: EventScreen = %EventScreen
@onready var year_counter: YearCounter = %YearCounter
@onready var event_manager: EventManager = $EventManager
@onready var music_manager = $MusicManager

@onready var district_1: District = %District1
@onready var district_2: District = %District2
@onready var district_3: District = %District3
@onready var district_4: District = %District4

var current_contentement: float

func _ready():
	LoadTitleScreen()
	SignalManager.AddContentement.connect(AddContentement)

func LoadTitleScreen():
	title_screen.show()
	music_manager.PlayMusic(Enums.Soundtrack.TITLE)

func Init():
	current_contentement = initial_contentement
	# districts
	district_1.Init()
	district_2.Init()
	district_3.Init()
	district_4.Init()
	year_counter.YearCounterUpdater()
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
