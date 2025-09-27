extends TextureRect

@onready var good_ending: TextureRect = $"."

func _ready():
	SignalManager.GoodEnding.connect(goodEnding)

func goodEnding():
	good_ending.visible = true
