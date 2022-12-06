extends CanvasLayer


signal restart()
signal quit_game()
onready var gameover: = $gameover
func _ready() -> void:
	pass 




func _on_restart_pressed() -> void:
	emit_signal("restart")
	pass # Replace with function body.


func _on_exit_pressed() -> void:
	emit_signal("quit_game")
	pass # Replace with function body.
