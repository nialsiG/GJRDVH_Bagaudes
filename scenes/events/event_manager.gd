extends Node
class_name EventManager

@export_group("Events")
@export var initial_events: Array[EventResource]

# This is the list of events that is changed dynamically during the game
var event_list: Array[EventResource]
var current_year: int

func _ready():
	#SignalManager.AskForEvent.connect(SendEvent)
	SignalManager.UnlockEvent.connect(AddEventToList)
	SignalManager.RemoveEvent.connect(RemoveEventFromList)
	SignalManager.AddYear.connect(CheckEventByYear)

func Init(starting_year: int):
	event_list.clear()
	event_list.append_array(initial_events)
	current_year = starting_year
	await get_tree().create_timer(2.0).timeout
	CheckEventByYear(0)

#func SendEvent(popup: PopupEvent):
	#var event = event_list.pick_random()
	#popup.SetCurrentEvent(event)
	#await get_tree().create_timer(0.5).timeout
	#event_list.erase(event)

func CheckEventByYear(year: int):
	current_year += year
	for event in event_list:
		if event.year == current_year:
			var district: District
			if event.district == Enums.DistrictType.NONE:
				district = PickRandomDistrict()
			else:
				district = PickDistrict(event.district)
			district.PopupSpawn(event)

func PickRandomDistrict():
	var districts = get_tree().get_nodes_in_group("district")
	var district = districts[randi_range(0, districts.size() - 1)]
	return district as District
 
func PickDistrict(district: Enums.DistrictType):
	for d in get_tree().get_nodes_in_group("district"):
		if d.district_type == district:
			return d as District

func AddEventToList(event: EventResource):
	event_list.append(event)

func RemoveEventFromList(event: EventResource):
	event_list.erase(event)
