extends Node2D


onready var quick_save: = true
onready var anim: = $anim_angel
onready var popUp: = $popup
onready var first_touch: = true
onready var savefile: = SaveFile
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_area_angel_body_entered(body: Node) -> void:
	if quick_save:
		print("Save")
		Checkpoint.last_point = self.global_position
		quick_save = false
		anim.play("heal")
	if first_touch and !savefile.saved:
		savefile.saved = true
		popUp.visible = true
		first_touch = false
		anim.play("firstactive")
	if savefile.saved:
		anim.play("activated")

func _on_area_angel_body_exited(body: Node) -> void:
	popUp.visible = false
	quick_save = true

