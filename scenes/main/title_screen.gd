extends Control

@onready var credits_menu: Control = $BGTextureRect/CreditsMenu
@onready var options_menu: Control = $BGTextureRect/OptionsMenu
@onready var start_menu: Control = $BGTextureRect/StartMenu

func Reset():
	credits_menu.hide()
	options_menu.hide()
	start_menu.show()

func _on_close_options_button_pressed():
	Reset()


func _on_credits_button_pressed():
	credits_menu.show()
	options_menu.hide()
	start_menu.hide()


func _on_options_button_pressed():
	credits_menu.hide()
	options_menu.show()
	start_menu.hide()
