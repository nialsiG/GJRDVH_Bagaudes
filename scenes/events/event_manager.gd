extends Node
class_name EventManager

@export_group("Events")
@export var initial_events: Array[EventResource]

var event_list: Array[EventResource]

func Init():
	event_list.clear()
	event_list = initial_events

func SelectRandomEvent():
	var selected_event: EventResource = event_list.pick_random()
	var selected_district: Enums.DistrictType
	if selected_event.district == Enums.DistrictType.NONE:
		selected_district = Enums.DistrictType.keys()[randi_range(0, Enums.DistrictType.size() - 1)]
		# note : it only works if the last value of Enums.DistrictType is NONE
	else:
		selected_district = selected_event.district
	SignalManager.TriggerEvent.emit(selected_event, selected_district)
	
