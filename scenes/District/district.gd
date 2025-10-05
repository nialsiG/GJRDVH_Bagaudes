extends Node2D
class_name District
@export_file("*.tscn") var PopupPrefab : String
@export var district_type: Enums.DistrictType
@export var spawn_position: Array[Marker2D]
@export var district_color: Color
@export var district_color_on_hover: Color
@export var max_health: float = 100.0
@export var initial_health: float = 25.0
@onready var health_component = $HealthComponent

@onready var health_bar: TextureProgressBar = %HealthBar
@onready var sprite_2d: Sprite2D = $Sprite2D

var spawn_position_counter: int = 0
var health: float
var popup: PackedScene
var popupPosition : Vector2 = Vector2(10,10)

func _ready():
	popup = load(PopupPrefab)
	#SignalManager.spawn_popup_requested.connect(NewPopup)
	add_to_group("district")
	SignalManager.CheckGameOver.connect(CheckGameOver)

#func NewPopup():
	#PopupSpawn(Vector2(10,10))

#func input(event):
	#if event is InputEventKey and event.pressed and event.keycode == KEY_CAPSLOCK :
		#AddHealth(-10)


func Init():
	health = initial_health
	health_bar.max_value = max_health
	health_bar.value = health
	HideColor()
	## test for the popup 
	#await get_tree().create_timer(3).timeout
	#PopupSpawn(Vector2(10, 10))
	#HideInfo()
	#DisplayInfo()

func DisplayColor():
	HideAll()
	#health_component.show()
	sprite_2d.set_modulate(district_color_on_hover)

func HideColor():
	#health_component.hide()
	sprite_2d.set_modulate(district_color)

func HideAll():
	for district in get_tree().get_nodes_in_group("district"):
		district.HideColor()

func AddHealth(amount: float):
	health += amount
	#health_bar.value = health
	var tween = create_tween()
	tween.tween_property(health_bar, "value", health, 1.0)
	print("health = ", health, '/', max_health)
	if health <= 0 :
		health = 0
	elif health >= max_health:
		health = max_health

#func PopupSpawn(origin:Vector2 = Vector2(0, 0)):
func PopupSpawn(event: EventResource):
	var instance : PopupEvent = popup.instantiate()
	add_child(instance)
	#print("spawn_position_counter: ", spawn_position_counter)
	#instance.position = popupPosition
	instance.global_position = spawn_position[spawn_position_counter].global_position
	spawn_position_counter += 1
	if spawn_position_counter >= spawn_position.size():
		spawn_position_counter = 0
	#instance.init()
	instance.Init(event)

func CheckGameOver():
	if health <= 0: 
		SignalManager.EpidemicEnding.emit()

func _on_area_2d_mouse_entered():
	pass
	#for district in get_tree().get_nodes_in_group("district"):
		#district.HideInfo()
		#DisplayInfo()
