extends CanvasLayer

onready var control: = $Control
onready var panel: = $Control/PopupPanel
onready var file: = File.new()
onready var delete_file: = Directory.new()
signal close()
signal start()
signal continue_game()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_PopupPanel_popup_hide() -> void:
	emit_signal("close")
	


func slot0() -> void:
	SaveFile.slot = SaveFile.save
	if SaveFile.new_game == true:
		if file.file_exists(SaveFile.save):
			delete_file.remove(SaveFile.save)
			emit_signal("start")
		else:
			emit_signal("start")
	else:
		if file.file_exists(SaveFile.save):
			emit_signal("continue_game")
	panel.visible = false

func slot1() -> void:
	SaveFile.slot = SaveFile.save1
	if SaveFile.new_game == true:
		if file.file_exists(SaveFile.save1):
			delete_file.remove(SaveFile.save1)
			emit_signal("start")
		else:
			emit_signal("start")
	else:
		if file.file_exists(SaveFile.save1):
			emit_signal("continue_game")
	panel.visible = false
func slot2() -> void:
	SaveFile.slot = SaveFile.save2
	if SaveFile.new_game == true:
		if file.file_exists(SaveFile.save2):
			delete_file.remove(SaveFile.save2)
			emit_signal("start")
		else:
			emit_signal("start")
	else:
		if file.file_exists(SaveFile.save2):
			emit_signal("continue_game")
	panel.visible = false
