extends TextureRect

@onready var revolution_ending_screen: TextureRect = $"."

func _ready():
	SignalManager.RevolutionEnding.connect(RevolutionEnding)

func RevolutionEnding():
	revolution_ending_screen.visible = true
