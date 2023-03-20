extends Node
class_name Idle_Bat

onready var parent: = get_parent()

func _physics_process(delta: float) -> void:
	
	pass
	
func enter():
	print("your on idle")
	yield(get_tree().create_timer(5.0), "timeout")
	exit(parent.WANDER)

func exit(next_state):
	parent.change_to(next_state)
