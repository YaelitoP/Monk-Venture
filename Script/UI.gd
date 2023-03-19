extends CanvasLayer



onready var gameover: = $gameover
onready var camera: = $gameover/Camera2D
func _ready() -> void:
	pass 


func _physics_process(_delta: float) -> void:
	if gameover.visible == true:
		camera.current = true

func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()
	pass # Replace with function body.


func _on_exit_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.
