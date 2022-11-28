extends CanvasLayer


onready var screen_button: = $Control/PopupPanel/VBoxContainer/CheckButton
onready var panel: = $Control/PopupPanel
signal closed()
signal change_resolution()


func _ready() -> void:
	
	if OS.window_fullscreen == true:
		screen_button.set_pressed(true)
	else:
		screen_button.set_pressed(false)



func _on_PopupPanel_popup_hide() -> void:
	emit_signal("closed")


func _on_CheckButton_toggled(button_pressed: bool) -> void:
	emit_signal("change_resolution")
	if SaveFile.fullscreen == true:
		SaveFile.fullscreen = false
	else:
		SaveFile.fullscreen = true
