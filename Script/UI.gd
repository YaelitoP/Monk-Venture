extends CanvasLayer



onready var gameover: = $gameover
func _ready() -> void:
	pass 




func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()
	pass # Replace with function body.


func _on_exit_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.
