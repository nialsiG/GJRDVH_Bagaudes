extends Resource
class_name EventResource

@export_group("Event")
@export var name: String
@export_multiline var description: String
@export var available_on_start: bool = true
@export var district: Enums.DistrictType = Enums.DistrictType.NONE
@export var year: int = 1830

@export_group("Popup")
@export var texture: Texture2D
@export var event_sound: Enums.Sound

@export_group("Choice1")
@export_multiline var choice_1: String
@export var choice_1_contentement: float
@export var choice_1_health: float
@export var choice_1_time: int
@export var choice_1_unlockable_events: Array[EventResource]
@export_multiline var choice_1_follow_up: String

@export_group("Choice2")
@export_multiline var choice_2: String
@export var choice_2_contentement: float
@export var choice_2_health: float
@export var choice_2_time: int
@export var choice_2_unlockable_events: Array[EventResource]
@export_multiline var choice_2_follow_up: String
