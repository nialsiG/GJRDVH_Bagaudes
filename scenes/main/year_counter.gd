extends Label
class_name YearCounter

var Year : int = 1789
@onready var year_counter_label: Label = %YearCounter

func YearCounterUpdater() :
	year_counter_label.text = str("Year ", Year)
