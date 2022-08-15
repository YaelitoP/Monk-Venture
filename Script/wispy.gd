extends RigidBody2D
class_name Wispy

onready var coll: = $coll_wisp
onready var anim: = $anim_wisp
onready var hurtbox: = $Hurtbox
onready var coll_hurtbox: = $Hurtbox/coll_hurt

var intruder: Object

func _ready() -> void:
	pass 

func _physics_process(delta: float) -> void:
	
	if is_instance_valid(self):
		for collide in self.get_colliding_bodies():
			if collide.is_in_group("player"):
				if is_instance_valid(anim):
					anim.play("dead")
				self.set_sleeping(true)
				

func _on_Hurtbox_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		intruder = body
