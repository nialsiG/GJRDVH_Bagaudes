extends Resource
class_name EventResource

@export_group("Event")
@export var name: String
@export_multiline var description: String
@export var texture: Texture2D
@export var available_on_start: bool = true
@export var district: Enums.DistrictType = Enums.DistrictType.NONE

@export_multiline var choice_1: String
@export var choice_1_contentement: float
@export var choice_1_health: float
@export var choice_1_time: int
@export var choice_1_unlockable_events: Array[EventResource]

@export_multiline var choice_2: String
@export var choice_2_contentement: float
@export var choice_2_health: float
@export var choice_2_time: int
@export var choice_2_unlockable_events: Array[EventResource]
