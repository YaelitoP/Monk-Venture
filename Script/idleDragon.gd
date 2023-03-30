extends Node
class_name idleDragon

onready var parent: = get_parent()
onready var dragon: Object 
onready var fsm : Object
onready var getOut: bool = false

func _physics_update(_delta: float) -> void:
	wait()
	if !getOut:
		dragon.anim.play("idle")
	else:
		exit(fsm.WANDER)
	
func enter() -> void:
	getOut = false
	print("estas en idle")

func exit(next_state) -> void:
	parent.change_to(next_state)
	
func wait():
	if dragon.wait.time_left == 0:
		getOut = true
		dragon.create_target()
