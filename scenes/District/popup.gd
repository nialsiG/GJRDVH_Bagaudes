extends Control

class_name PopupEvent

@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar

var current_event: EventResource
var can_be_clicked: bool = true

func _ready():
	SignalManager.AddYear.connect(AddYear)

#func init():
	#print("Popup ready at position: ", position)
	#SignalManager.AskForEvent.emit(self)

func Init(event: EventResource):
	current_event = event
	texture_progress_bar.texture_under = event.texture
	texture_progress_bar.texture_progress = event.texture
	texture_progress_bar.max_value = 5
	texture_progress_bar.value = 0

func AddYear(amount: int):
	texture_progress_bar.value += amount
	if texture_progress_bar.value >= texture_progress_bar.max_value:
		can_be_clicked = false
		var tween = get_tree().create_tween()
		tween.tween_property(self, "modulate", Color.TRANSPARENT, 2.0)
		tween.tween_callback(queue_free)
#func SetCurrentEvent(event: EventResource):
	#current_event = event

func _gui_input(event):
	if event is InputEventMouseButton and event.pressed and can_be_clicked:
		print("Popup clicked !")
		var district: District = get_parent()
		SignalManager.OpenEvent.emit(current_event, district)
