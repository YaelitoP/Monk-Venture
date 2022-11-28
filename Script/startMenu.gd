extends CanvasLayer

signal load_game()
signal quit_game()
signal options_screen()


func _ready() -> void:
	pass # Replace with function body.

func _on_Button_pressed() -> void:
	emit_signal("load_game")
	pass # Replace with function body.


func exit_press() -> void:
	emit_signal("quit_game")
	pass # Replace with function body.

func _on_options_pressed() -> void:
	emit_signal("options_screen")
	pass # Replace with function body.
