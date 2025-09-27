extends Node

@export var initial_contentement: float = 1.0

@onready var title_screen = %TitleScreen
@onready var event_screen: EventScreen = %EventScreen
@onready var district_1: District = %District1
@onready var year_counter: YearCounter = %YearCounter

var current_contentement: float

func _ready():
	title_screen.show()

func Init():
	current_contentement = initial_contentement
	district_1.Init()
	# for the test, generate event after 3 sec
	await get_tree().create_timer(3.0).timeout
	event_screen.ChooseFirstEvent(district_1)
	year_counter.YearCounterUpdater()


func _on_start_button_pressed():
	Init()
	title_screen.hide()
