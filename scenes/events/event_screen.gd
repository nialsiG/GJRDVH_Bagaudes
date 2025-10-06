extends Control
class_name EventScreen

@export_group("Events")
@export var events: Array[EventResource]

@export_group("Unlockable assets")
@export var trash_asset: UnlockableAsset
@export var boat_asset: UnlockableAsset
@export var park_asset: UnlockableAsset

@onready var event_title_label: Label = %EventTitleLabel
@onready var event_description_label: Label = %EventDescriptionLabel
@onready var event_texture_rect: TextureRect = %EventTextureRect
@onready var event_choice_button_1: TextureButton = %EventChoiceButton1
@onready var event_choice_1_label: Label = %EventChoice1Label
@onready var event_choice_button_2: TextureButton = %EventChoiceButton2
@onready var event_choice_2_label: Label = %EventChoice2Label
@onready var follow_up_button: TextureButton = %FollowUpButton
@onready var follow_up_label: Label = %FollowUpLabel
@onready var event_deactivate_click_panel: Panel = %EventDeactivateClickPanel
@onready var later_button = %LaterButton

enum choice {
	FIRST,
	SECOND
}
var current_choice: choice
var current_event_resource: EventResource
var current_district: District
var time_on_close: int
var help_to_decision: bool
var current_popup: PopupEvent

func _ready():
	hide()
	SignalManager.OpenEvent.connect(OpenEvent)

func Reset():
	hide()
	event_choice_button_1.show()
	event_choice_button_2.show()
	event_deactivate_click_panel.hide()
	follow_up_button.hide()

func OpenEvent(event: EventResource, district: District, popup: PopupEvent):
	#print("district: ", district)
	#print("event: ", event.name)
	SignalManager.PlaySound.emit(event.event_sound)
	UpdateEvent(event)
	current_district = district
	current_popup = popup
	show()

func UpdateEvent(event_resource: EventResource):
	current_event_resource = event_resource
	event_title_label.text = event_resource.name
	event_description_label.text = event_resource.description
	event_texture_rect.texture = event_resource.texture
	# choice 1
	var choice_text_1: String = event_resource.choice_1
	if help_to_decision:
		if event_resource.choice_1_time > 0 :
			choice_text_1 = str(choice_text_1, "\n(+", event_resource.choice_1_time, " années)")
		if event_resource.choice_1_health > 0.0:
			choice_text_1 = str(choice_text_1, " (+", event_resource.choice_1_health, " santé)")
		elif event_resource.choice_1_health < 0.0:
			choice_text_1 = str(choice_text_1, " (", event_resource.choice_1_health, " santé)")
		if event_resource.choice_1_contentement > 0.0:
			choice_text_1 = str(choice_text_1, " (+", event_resource.choice_1_contentement, " contentement)")
		elif event_resource.choice_1_contentement < 0.0:
			choice_text_1 = str(choice_text_1, " (", event_resource.choice_1_contentement, " contentement)")
	event_choice_1_label.text = choice_text_1
	# choice 2
	var choice_text_2: String = event_resource.choice_2
	if help_to_decision:
		if event_resource.choice_2_time > 0 :
			choice_text_2 = str(choice_text_2, "\n(+", event_resource.choice_2_time, " années)")
		if event_resource.choice_2_health > 0.0:
			choice_text_2 = str(choice_text_2, " (+", event_resource.choice_2_health, " santé)")
		elif event_resource.choice_2_health < 0.0:
			choice_text_2 = str(choice_text_2, " (", event_resource.choice_2_health, " santé)")
		if event_resource.choice_2_contentement > 0.0:
			choice_text_2 = str(choice_text_2, " (+", event_resource.choice_2_contentement, " contentement)")
		elif event_resource.choice_2_contentement < 0.0:
			choice_text_2 = str(choice_text_2, " (", event_resource.choice_2_contentement, " contentement)")
	event_choice_2_label.text = choice_text_2
	show()


func CloseEvent():
	SignalManager.PlaySound.emit(Enums.Sound.VALIDATE)
	hide()
	later_button.show()
	event_deactivate_click_panel.hide()
	event_choice_button_1.show()
	event_choice_button_2.show()
	follow_up_button.hide()
	SignalManager.RemoveEvent.emit(current_event_resource)
	SignalManager.CheckGameOver.emit()
	for year in time_on_close:
		await get_tree().create_timer(0.2).timeout
		SignalManager.AddYear.emit(1)


func FollowUp(follow_up_text: String):
	event_deactivate_click_panel.show()
	event_choice_button_1.hide()
	event_choice_button_2.hide()
	later_button.hide()
	event_description_label.text = follow_up_text
	follow_up_button.show()
	current_popup.Remove()
	current_popup = null

func TriggerFirstEffect():
	time_on_close = current_event_resource.choice_1_time
	if current_event_resource.choice_1_contentement:
		SignalManager.AddContentement.emit(current_event_resource.choice_1_contentement)
	if current_event_resource.choice_1_health:
		current_district.AddHealth(current_event_resource.choice_1_health)
	if current_event_resource.choice_1_unlockable_events.size() > 0:
		for event in current_event_resource.choice_1_unlockable_events:
			SignalManager.UnlockEvent.emit(event)
	if current_event_resource.choice_1_unlockable_asset == Enums.UnlockableAssets.PARK:
		park_asset.Unlock()
	elif current_event_resource.choice_1_unlockable_asset == Enums.UnlockableAssets.TRASH:
		trash_asset.Unlock()
	elif current_event_resource.choice_1_unlockable_asset == Enums.UnlockableAssets.BOAT:
		boat_asset.Unlock()

func TriggerSecondEffect():
	time_on_close = current_event_resource.choice_2_time
	if current_event_resource.choice_2_contentement:
		SignalManager.AddContentement.emit(current_event_resource.choice_2_contentement)
	if current_event_resource.choice_2_health:
		current_district.AddHealth(current_event_resource.choice_2_health)
	if current_event_resource.choice_2_unlockable_events.size() > 0:
		for event in current_event_resource.choice_2_unlockable_events:
			SignalManager.UnlockEvent.emit(event)
	if current_event_resource.choice_2_unlockable_asset == Enums.UnlockableAssets.PARK:
		park_asset.Unlock()
	elif current_event_resource.choice_2_unlockable_asset == Enums.UnlockableAssets.TRASH:
		trash_asset.Unlock()
	elif current_event_resource.choice_2_unlockable_asset == Enums.UnlockableAssets.BOAT:
		boat_asset.Unlock()

func _on_event_choice_button_1_pressed():
	SignalManager.PlaySound.emit(Enums.Sound.VALIDATE)
	current_choice = choice.FIRST
	#if current_event_resource.choice_1_contentement:
		#SignalManager.AddContentement.emit(current_event_resource.choice_1_contentement)
	#if current_event_resource.choice_1_health:
		#current_district.AddHealth(current_event_resource.choice_1_health)
	#if current_event_resource.choice_1_unlockable_events.size() > 0:
		#for event in current_event_resource.choice_1_unlockable_events:
			#SignalManager.UnlockEvent.emit(event)
	var follow_up_text = current_event_resource.choice_1_follow_up
	if current_event_resource.choice_1_time > 0 :
		follow_up_text = str(follow_up_text, "\n(+", current_event_resource.choice_1_time, " années)")
	if current_event_resource.choice_1_health > 0.0:
		follow_up_text = str(follow_up_text, " (+", current_event_resource.choice_1_health, " santé)")
	elif current_event_resource.choice_1_health < 0.0:
		follow_up_text = str(follow_up_text, " (", current_event_resource.choice_1_health, " santé)")
	if current_event_resource.choice_1_contentement > 0.0:
		follow_up_text = str(follow_up_text, " (+", current_event_resource.choice_1_contentement, " contentement)")
	elif current_event_resource.choice_1_contentement < 0.0:
		follow_up_text = str(follow_up_text, " (", current_event_resource.choice_1_contentement, " contentement)")
	FollowUp(follow_up_text)


func _on_event_choice_button_2_pressed():
	SignalManager.PlaySound.emit(Enums.Sound.VALIDATE)
	current_choice = choice.SECOND
	#if current_event_resource.choice_2_contentement:
		#SignalManager.AddContentement.emit(current_event_resource.choice_2_contentement)
	#if current_event_resource.choice_2_health:
		#current_district.AddHealth(current_event_resource.choice_2_health)
	#if current_event_resource.choice_2_unlockable_events.size() > 0:
		#for event in current_event_resource.choice_2_unlockable_events:
			#SignalManager.UnlockEvent.emit(event)
	var follow_up_text = current_event_resource.choice_2_follow_up
	if current_event_resource.choice_2_time > 0 :
		follow_up_text = str(follow_up_text, "\n(+", current_event_resource.choice_2_time, " années)")
	if current_event_resource.choice_2_health > 0.0:
		follow_up_text = str(follow_up_text, " (+", current_event_resource.choice_2_health, " santé)")
	elif current_event_resource.choice_2_health < 0.0:
		follow_up_text = str(follow_up_text, " (", current_event_resource.choice_2_health, " santé)")
	if current_event_resource.choice_2_contentement > 0.0:
		follow_up_text = str(follow_up_text, " (+", current_event_resource.choice_2_contentement, " contentement)")
	elif current_event_resource.choice_2_contentement < 0.0:
		follow_up_text = str(follow_up_text, " (", current_event_resource.choice_2_contentement, " contentement)")
	FollowUp(follow_up_text)


func _on_follow_up_button_pressed():
	SignalManager.PlaySound.emit(Enums.Sound.VALIDATE)
	if current_choice == choice.FIRST:
		TriggerFirstEffect()
	elif current_choice == choice.SECOND:
		TriggerSecondEffect()
	CloseEvent()

func HideAllDistrictColors():
	for district in get_tree().get_nodes_in_group("district"):
		district.HideColor()

func _on_later_button_pressed():
	HideAllDistrictColors()
	hide()
