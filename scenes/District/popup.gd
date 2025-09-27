extends Control

class_name PopupEvent

func init():
	print("Popup ready at position: ", position)

func _gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		print("Popup clicked !")
