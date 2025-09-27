extends Node
class_name EventManager

@export_group("Events")
@export var initial_events: Array[EventResource]

# This is the list of events that is changed dynamically during the game
var event_list: Array[EventResource]

func _ready():
	SignalManager.AskForEvent.connect(SendEvent)

func Init():
	event_list.clear()
	event_list = initial_events

func SendEvent(popup: PopupEvent):
	var event = event_list.pick_random()
	popup.SetCurrentEvent(event)
	await get_tree().create_timer(0.5).timeout
	event_list.erase(event)
 
