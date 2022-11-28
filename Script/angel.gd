extends Node2D


onready var quick_save: = true
onready var anim: = $anim_angel
onready var popUp: = $popup
onready var first_touch: = true
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_area_angel_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		if first_touch:
			SaveFile.saved = true
			popUp.visible = true
			first_touch = false
			anim.play("firstactive")
			SaveFile.save_data()
		elif quick_save:
			SaveFile.last_point = self.global_position
			quick_save = false
			anim.play("heal")
			SaveFile.save_data()
		elif SaveFile.saved and !first_touch:
			anim.play("activated")

func _on_area_angel_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		popUp.visible = false
		quick_save = true


func save():
	var game_data: = {
		"name" : self.get_filename(),
		"parent" : self.get_parent().get_path(),
		"pos_x" : self.get_position().x,
		"pos_y" : self.get_position().y,
		"first_touch" : first_touch,
	}
	return game_data
