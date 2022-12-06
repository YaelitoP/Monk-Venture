extends CanvasLayer


onready var screen_button: = $Control/PopupPanel/VBoxContainer/CheckButton
onready var panel: = $Control/PopupPanel
signal closed()
signal change_resolution()


func _ready() -> void:
	
	if SaveFile.fullscreen == true:
		screen_button.set_pressed_no_signal(true)
	else:
		screen_button.set_pressed_no_signal(false)



func _on_PopupPanel_popup_hide() -> void:
	emit_signal("closed")


func _on_CheckButton_toggled(button_pressed: bool) -> void:
	if button_pressed:
		SaveFile.fullscreen = true
	else:
		SaveFile.fullscreen = false
	emit_signal("change_resolution")
