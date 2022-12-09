extends CanvasLayer

signal start_game()
signal quit_game()
signal options_screen()
signal continue_game()

const save: = "res://Saves/game_data.save"
const save1: = "res://Saves/game_data1.save"
const save2: = "res://Saves/game_data2.save"

onready var continue_button: = $menu/VBoxContainer/Button4
onready var start_button: = $menu/VBoxContainer/Button
onready var options_button: = $menu/VBoxContainer/Button3
onready var exit_button: = $menu/VBoxContainer/Button2

func _ready() -> void:
	var file = File.new()
	if file.file_exists(save) or file.file_exists(save1) or file.file_exists(save2):
		continue_button.set_visible(true)
	else:
		continue_button.set_visible(false)


func continue_pressed() -> void:
	SaveFile.new_slot = false
	emit_signal("continue_game")
	pass # Replace with function body.


func start_pressed() -> void:
	SaveFile.new_slot = true
	emit_signal("start_game")
	pass # Replace with function body.

func _on_options_pressed() -> void:
	emit_signal("options_screen")
	pass # Replace with function body.

func exit_press() -> void:
	SaveFile.save_config()
	get_tree().quit()
	pass # Replace with function body.






