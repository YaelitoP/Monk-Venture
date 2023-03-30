extends Node
class_name seekDragon

onready var parent: = get_parent()
onready var dragon: Object 
onready var fsm : Object
onready var speed: int = 250
onready var target: Object
onready var through: int = 0
onready var getOut: bool = false
export var cooldown: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_update(_delta: float) -> void:
	for i in dragon.sight.get_overlapping_bodies():
		if i.is_in_group("player"):
			getOut = false
			dragon.target_position = i.global_position
	
	if dragon.wait.time_left == 0 and getOut:
		exit(fsm.IDLE)
	
	
	if fsm.direction.x < 0:
		dragon.anim.flip_h = true
	if fsm.direction.x > 0:
		dragon.anim.flip_h = false

	if dragon.target_position.distance_to(dragon.global_position) > 100:
		dragon.anim.play("idle")
		fsm.direction = dragon.global_position.direction_to(dragon.target_position)
		dragon.move_and_slide(fsm.direction * speed/2, Vector2.UP)
	elif !cooldown:
		dragon.move_and_slide(fsm.direction * speed, Vector2.UP)
		dragon.animation.play("attack")
	else:
		countDown()
		
		

	

func _on_playerDetector_body_entered(body: Node) -> void:
	dragon.wait.stop()
	if fsm.state != fsm.SEEK:
		exit(fsm.SEEK)
	target = body

func countDown():
	if dragon.timer.time_left == 0:
		cooldown = false

func enter() -> void:
	print("Estás en seek")

func exit(next_state) -> void:
	fsm.change_to(next_state)


func _on_playerDetector_body_exited(body: Node) -> void:
	dragon.wait.start()
	getOut = true
