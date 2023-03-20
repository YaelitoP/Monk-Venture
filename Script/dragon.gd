extends KinematicBody2D
class_name bat

onready var anim: = $anim_bat
onready var MACHINE: = $stateMachine
onready var timer: = $Timer
onready var spawn: = global_position
onready var current_position: = global_position
onready var target_position: = global_position

var hp: = 100
var max_hp: = 150

func _physics_process(delta: float) -> void:
	if !hp <= 0:
		if MACHINE.has_method("_physics_process()"):
			MACHINE._physics_process(delta)
	else:
		anim.play("murido")
	pass
