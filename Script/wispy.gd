extends RigidBody2D
class_name Wispy

onready var coll: = $coll_wisp
onready var anim: = $anim_wisp
onready var hurtbox: = $hurtbox
onready var coll_hurtbox: = $hurtbox/coll_hurtbox
onready var time_alive = $time_alive
var intruder: Object

func _ready() -> void:
	coll.disabled = false
	

func _physics_process(_delta: float) -> void:
	
	if time_alive.time_left == 0:
		anim.play("dead")
	if is_instance_valid(self):
		for collide in self.get_colliding_bodies():
			if collide.is_in_group("player"):
				coll.disabled = true
				anim.play("dead")
				self.set_sleeping(true)
			if collide.is_in_group("floor"):
				coll.disabled = true
				anim.play("dead")
				self.set_sleeping(true)
			
		
	


func _on_Hurtbox_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		intruder = body
	


