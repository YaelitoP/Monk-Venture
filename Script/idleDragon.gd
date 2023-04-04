extends Node
class_name idleDragon

onready var parent: = get_parent()
onready var dragon: Object 
onready var fsm : Object
onready var waiting: bool = false

func _physics_update(_delta: float) -> void:
	if !waiting:
		dragon.animation.play("idle")
		wait()

	
func enter() -> void:
	waiting = false
	print("estas en idle")

func exit(next_state) -> void:
	parent.change_to(next_state)
	
func wait():
	waiting = true
	yield(get_tree().create_timer(rand_range(1.5, 2.5)), "timeout")
	if fsm.state == fsm.IDLE:
		dragon.create_target()
		exit(fsm.get_random_state())
