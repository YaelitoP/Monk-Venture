extends CanvasLayer

signal load_game()
signal quit_game()
signal options_screen()
signal continue_game()

const save: = "res://Saves/game_data.save"

onready var continue_button: = $menu/VBoxContainer/Button4
onready var start_button: = $menu/VBoxContainer/Button
onready var options_button: = $menu/VBoxContainer/Button3
onready var exit_button: = $menu/VBoxContainer/Button2

func _ready() -> void:
	var file = File.new()
	if file.file_exists(save):
		continue_button.set_visible(true)
	else:
		continue_button.set_visible(false)

func _on_Button_pressed() -> void:
	SaveFile.new_game = true
	emit_signal("load_game")
	pass # Replace with function body.


func exit_press() -> void:
	SaveFile.save_config()
	emit_signal("quit_game")
	pass # Replace with function body.

func _on_options_pressed() -> void:
	emit_signal("options_screen")
	pass # Replace with function body.


func _on_Button4_pressed() -> void:
	SaveFile.new_game = false
	emit_signal("continue_game")
	pass # Replace with function body.

