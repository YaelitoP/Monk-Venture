extends KinematicBody2D

onready var anim: = $anim_wizard
onready var area: = $area_wizard
onready var coll: = $coll_wizard
onready var aiming: = $aiming
onready var aim0: = $aiming/aim1
onready var aim1: = $aiming/aim2
onready var aim2: = $aiming/aim3
onready var shot_speed: = $shot_speed
onready var bullet: = preload("res://tscn/wispy.tscn")

var bullet_speed: = 500
var angle_shot: = Vector2.ZERO
var collision0: Node
var collision1: Node
var collision2: Node

var sight: = 100

var intruder_pos: Vector2

var intruder: Object
var is_shooting: = false

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	
	sprites()
	
	for collide in area.get_overlapping_bodies():
		if collide.is_in_group("player"):
			
			check_cast_to(collide)
			if is_shooting == false:
				is_shooting = true
				var bullet_shot: = bullet.instance()
				add_child(bullet_shot)
				shooting(collide, bullet_shot)
				yield(get_tree().create_timer(1.0), "timeout")
				is_shooting = false


func shooting(collide, bullet_shot):
	if collide.is_in_group("player"):
		bullet_shot.to_local(global_position)
		bullet_shot.set_rotation_degrees(bullet_shot.get_angle_to(collide.global_position))
		bullet_shot.apply_impulse(Vector2.ZERO, Vector2(bullet_speed, 0).rotated(aim1.get_cast_to().angle()))

func _on_area_wizard_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		intruder = body
		
func check_cast_to(collide):
	intruder_pos = global_position.direction_to(collide.get_position()) * sight
	
	aim0.set_cast_to(intruder_pos)
	aim1.set_cast_to(intruder_pos)
	aim2.set_cast_to(intruder_pos)
	if aim0.is_colliding():
		collision0 = aim0.get_collider()
	if aim1.is_colliding():
		collision1 = aim1.get_collider()
	if aim2.is_colliding():
		collision2 = aim2.get_collider()

func sprites():
	if !anim.is_playing():
		anim.play("idle")
	elif is_shooting:
		anim.play("shoot")
