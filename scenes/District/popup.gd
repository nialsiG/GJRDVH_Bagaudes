extends Control

class_name PopupEvent

@export var duration: int

@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar
@onready var glow_texture_rect = $GlowTextureRect

var current_event: EventResource
var can_be_clicked: bool = true
var glow_power: float = 1.0
var glow_speed: float = 1.0

func _ready():
	SignalManager.AddYear.connect(AddYear)
	add_to_group("popup")

func _process(delta):
	#glow_texture_rect.material.set_shader_parameter("glow_power", glow_power)
	texture_progress_bar.material.set_shader_parameter("glow_power", glow_power)
	# manage glowing power
	glow_power += delta * glow_speed
	if glow_power >= 2.0 and glow_speed > 0 or glow_power <= 1.0 and glow_speed < 0:
		glow_speed *= -1.0


#func init():
	#print("Popup ready at position: ", position)
	#SignalManager.AskForEvent.emit(self)

func Init(event: EventResource):
	SignalManager.PlaySound.emit(Enums.Sound.POPUP)
	current_event = event
	texture_progress_bar.texture_under = event.texture
	#texture_progress_bar.texture_progress = event.texture
	texture_progress_bar.max_value = duration
	texture_progress_bar.value = 0

func AddYear(amount: int):
	var tween = get_tree().create_tween()
	tween.tween_property(texture_progress_bar, "value", texture_progress_bar.value + amount, 1.0)
	if texture_progress_bar.value >= texture_progress_bar.max_value:
		Remove()
#func SetCurrentEvent(event: EventResource):
	#current_event = event

func Remove():
	can_be_clicked = false
	var remove_tween = get_tree().create_tween()
	remove_tween.tween_property(self, "modulate", Color.TRANSPARENT, 2.0)
	remove_tween.tween_callback(queue_free)

func _gui_input(event):
	if event is InputEventMouseButton and event.pressed and can_be_clicked:
		print("Popup clicked !")
		var district: District = get_parent()
		SignalManager.OpenEvent.emit(current_event, district, self)
