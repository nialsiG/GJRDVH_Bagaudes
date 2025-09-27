extends Node

@export var initial_contentement: float = 1.0

@onready var title_screen = %TitleScreen
@onready var event_screen: EventScreen = %EventScreen
@onready var district_1: District = %District1
@onready var year_counter: YearCounter = %YearCounter
@onready var event_manager: EventManager = $EventManager

var current_contentement: float

func _ready():
	title_screen.show()
	SignalManager.AddContentement.connect(AddContentement)

func Init():
	current_contentement = initial_contentement
	district_1.Init()
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
