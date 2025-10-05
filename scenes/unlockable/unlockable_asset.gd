extends Sprite2D
class_name UnlockableAsset

@export var frequency: float = 10
@export_range(0.0, 1.0) var amplitude: float = 0.03
@export var duration: float = 0.6
@export var is_visible_on_start: bool = false

@onready var wobble_timer: Timer = $Timer

func _ready():
	add_to_group("unlockable_asset")

func _process(delta):
	if !wobble_timer.is_stopped():
		var variation = sin(wobble_timer.time_left * frequency) * amplitude
		scale = Vector2(1.0 + variation, 1.0 - variation)

func Wobble():
	wobble_timer.start(duration)

func Reset():
	if is_visible_on_start:
		show()
	else:
		hide()

func Unlock():
	if is_visible_on_start:
		Wobble()
		await get_tree().create_timer(duration).timeout
		hide()
	else:
		show()
		Wobble()

func _on_timer_timeout():
	scale = Vector2(1.0, 1.0)
