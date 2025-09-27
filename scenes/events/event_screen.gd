extends Control
class_name EventScreen

@export_group("Events")
@export var events: Array[EventResource]

@onready var event_title_label: Label = %EventTitleLabel
@onready var event_description_label: Label = %EventDescriptionLabel
@onready var event_texture_rect: TextureRect = %EventTextureRect
@onready var event_choice_button_1: Button = %EventChoiceButton1
@onready var event_choice_1_label: Label = %EventChoice1Label
@onready var event_choice_button_2: Button = %EventChoiceButton2
@onready var event_choice_2_label: Label = %EventChoice2Label

var current_event_resource: EventResource
var current_district: District

func _ready():
	hide()
	SignalManager.OpenEvent.connect(OpenEvent)

func OpenEvent(event: EventResource, district: District):
	print("district: ", district)
	print("event: ", event.name)
	UpdateEvent(event)
	current_district = district
	show()

func UpdateEvent(event_resource: EventResource):
	event_title_label.text = event_resource.name
	event_description_label.text = event_resource.description
	event_texture_rect.texture = event_resource.texture
	event_choice_1_label.text = event_resource.choice_1
	event_choice_2_label.text = event_resource.choice_2
	current_event_resource = event_resource
	show()


func CloseEvent():
	hide()
	SignalManager.RemoveEvent.emit(current_event_resource)
	await get_tree().create_timer(1.0).timeout
	SignalManager.AddYear.emit(1)
	#TODO: sound

func _on_event_choice_button_1_pressed():
	if current_event_resource.choice_1_contentement:
		SignalManager.AddContentement.emit(current_event_resource.choice_1_contentement)
	if current_event_resource.choice_1_health:
		current_district.AddHealth(current_event_resource.choice_1_health)
	if current_event_resource.choice_1_unlockable_events.size() > 0:
		for event in current_event_resource.choice_1_unlockable_events:
			SignalManager.UnlockEvent.emit(event)
	CloseEvent()


func _on_event_choice_button_2_pressed():
	if current_event_resource.choice_2_contentement:
		SignalManager.AddContentement.emit(current_event_resource.choice_2_contentement)
	if current_event_resource.choice_2_health:
		current_district.AddHealth(current_event_resource.choice_2_health)
	if current_event_resource.choice_2_unlockable_events.size() > 0:
		for event in current_event_resource.choice__unlockable_events:
			SignalManager.UnlockEvent.emit(event)
	CloseEvent()
