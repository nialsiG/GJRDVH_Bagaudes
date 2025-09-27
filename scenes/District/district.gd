extends Node2D
class_name District
@export_file("*.tscn") var PopupPrefab : String

@onready var health_bar: ProgressBar = $HealthBar

var health: float = 10
var popup: PackedScene
var popupPosition : Vector2 = Vector2(10,10)

func _ready():
	popup = load(PopupPrefab)
	SignalManager.spawn_popup_requested.connect(NewPopup)
	
func NewPopup():
	PopupSpawn(Vector2(10,10))
	

func _gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		pass

func Init():
	health = health_bar.max_value
	health_bar.value = health_bar.max_value
	## test for the popup 
	#await get_tree().create_timer(3).timeout
	#PopupSpawn(Vector2(10, 10))


func AddHealth(amount: float):
	health += amount
	health_bar.value = health

func PopupSpawn(origin:Vector2):
	var instance : PopupEvent = popup.instantiate()
	add_child(instance)
	instance.position = popupPosition
	instance.init()
	
	
   
