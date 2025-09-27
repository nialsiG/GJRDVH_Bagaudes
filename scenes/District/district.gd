extends Control
class_name District
@export_file("*.tscn") var PopupPrefab : String

@onready var health_bar: ProgressBar = $HealthBar

var health: float = 10
var popup: PackedScene
var popupPosition : Vector2 = Vector2(10,10)

func _ready():
	popup = load(PopupPrefab)
	SignalManager.spawn_popup_requested.connect(NewPopup)
	add_to_group("district")
	
func NewPopup():
	PopupSpawn(Vector2(10,10))
	

func _gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		for district in get_tree().get_nodes_in_group("district"):
			district.HideInfo()
		await get_tree().create_timer(0.2).timeout
		DisplayInfo()

func Init():
	health = health_bar.max_value
	health_bar.value = health_bar.max_value
	## test for the popup 
	#await get_tree().create_timer(3).timeout
	#PopupSpawn(Vector2(10, 10))
	HideInfo()

func DisplayInfo():
	health_bar.show()

func HideInfo():
	health_bar.hide()

func HideAll():
	for district in get_tree().get_nodes_in_group("district"):
		district.HideInfo()

func AddHealth(amount: float):
	health += amount
	health_bar.value = health

func PopupSpawn(origin:Vector2):
	var instance : PopupEvent = popup.instantiate()
	add_child(instance)
	instance.position = popupPosition
	instance.init()
	
	
   
