extends Node
class_name Wander_Bat

onready var parent: = get_parent()
var point: = Vector2.ZERO
var speed: = 130

func _physics_process(delta: float) -> void:
	create_target()
	if owner.current_position.distance_to(owner.spawn) < 100:
		parent.direction = point * speed
		parent.direction = owner.move_and_slide(point, Vector2.UP)
		exit(parent.IDLE)
	if owner.current_position.distance_to(point) <= 0:
		pass
	pass

func enter():
	print("your on wander")
	yield(get_tree().create_timer(10.0), "timeout")

func create_target():
	if owner.current_position == owner.spawn:
		point = Vector2(rand_range(-64, 64), rand_range(-64, 64))
	elif owner.current_position == owner.target_position:
		point = Vector2(rand_range(-64, 64), rand_range(-64, 64))

func exit(next_state):
	parent.change_to(next_state)
