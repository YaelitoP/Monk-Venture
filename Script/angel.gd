extends Node2D


onready var first_save: = true
onready var anim: = $anim_angel
onready var first_touch: = true
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_area_angel_body_entered(body: Node) -> void:
	if first_save:
		print("enter")
		Checkpoint.last_point = self.global_position
		first_save = false
	if first_touch:
		anim.play("activated")

func _on_area_angel_body_exited(body: Node) -> void:
	first_save = true

