extends TextureRect
@onready var pandemic_ending_screen: TextureRect = $"."

func _ready():
	SignalManager.EpidemicEnding.connect(epidemicEnding)

func epidemicEnding():
	pandemic_ending_screen.visible = true
	
