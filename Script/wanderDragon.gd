extends Node
class_name WanderDragon

onready var dragon: Object
onready var fsm: Object

var target_vector: Vector2 = Vector2.ZERO
var point: Vector2 = Vector2.ZERO
var speed: int = 100
var boundaries = []

func _ready() -> void:
	randomize()

func _physics_update(_delta: float) -> void:
	if fsm.direction.x < 0:
		dragon.anim.flip_h = true
	if fsm.direction.x > 0:
		dragon.anim.flip_h = false
		
	if dragon.target_position.distance_to(dragon.global_position) > 80:
		fsm.direction = dragon.global_position.direction_to(dragon.target_position)
		dragon.move_and_slide(fsm.direction * speed, Vector2.UP)
	else:
		exit(fsm.get_random_state())

func enter() -> void:
	dragon.create_target()
	print("Estás en wander")

func exit(next_state) -> void:
	fsm.change_to(next_state)
