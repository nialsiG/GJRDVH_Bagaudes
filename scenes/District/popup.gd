extends Control

class_name PopupEvent

var current_event: EventResource

func init():
	print("Popup ready at position: ", position)
	SignalManager.AskForEvent.emit(self)

func SetCurrentEvent(event: EventResource):
	current_event = event

func _gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		print("Popup clicked !")
		var district: District = get_parent()
		SignalManager.OpenEvent.emit(current_event, district)
