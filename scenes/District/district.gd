extends Node2D
class_name District

@onready var health_bar: ProgressBar = $HealthBar

var health: float = 10

func Init():
	health = health_bar.max_value
	health_bar.value = health_bar.max_value

func AddHealth(amount: float):
	health += amount
	health_bar.value = health
