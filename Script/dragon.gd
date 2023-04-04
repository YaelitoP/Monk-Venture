extends KinematicBody2D
class_name dragonNode

onready var anim: Node = $anim_sprite
onready var animation: Node = $animation
onready var MACHINE: Node = $stateMachine
onready var timer: Node = $Timer
onready var wait: Node = $wait
onready var sight: Node = $playerDetector
onready var hurtbox: Node = $hurtbox
onready var spawn: = global_position
onready var current_position: = global_position
onready var target_position: Vector2
onready var limit: Object
onready var boundaries: = []
onready var hp: int = 100
export var hurted: bool = false
var dmg: int = 25

var max_hp: int = 150

func _physics_process(delta: float) -> void:
	
	if hp != 0 and !hurted:
		if MACHINE.has_method("_physics_process()"):
			MACHINE._physics_process(delta)
	elif hurted:
		animation.play("hurt")
	else:
		animation.play("die")


func create_target() -> void:
	boundaries = limit.get_boundaries()
	target_position = Vector2(rand_range(boundaries[0].x, boundaries[0].y), rand_range(boundaries[1].x, boundaries[1].y))


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.name == "area_attacks":
		hp = hp - dmg
		hurted = true
		
