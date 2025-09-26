extends Resource
class_name EventResource

@export_group("Event")
@export var name: String
@export_multiline var description: String
@export var texture: Texture2D

@export_multiline var choice_1: String
@export var choice_1_contentement: float
@export var choice_1_health: float

@export_multiline var choice_2: String
@export var choice_2_contentement: float
@export var choice_2_health: float
