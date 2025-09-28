extends TextureRect

func _ready():
	SignalManager.RevolutionEnding.connect(Open)

func Open():
	SignalManager.PlaySound.emit(Enums.Sound.CROWD)
	show()
