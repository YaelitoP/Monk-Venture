extends RigidBody2D


signal health_update(health)
signal death()

onready var anim: = $anim_wizard
onready var area_sight: = $area_wizard
onready var coll: = $coll_wizard
onready var aiming: = $aiming
onready var hurtbox: = $hurtbox
onready var aim0: = $aiming/aim1
onready var aim1: = $aiming/aim2
onready var aim2: = $aiming/aim3
onready var shot_speed: = $shot_speed
onready var bullet: = preload("res://tscn/wispy.tscn")
onready var parent: = get_parent()

var bullet_speed: = 500
var angle_shot: = Vector2.ZERO
var collision0: Node
var collision1: Node
var collision2: Node

export var health: = 100
export var max_health: = 200
var sight: = 100

var dmg_income = 0
var intruder_pos: Vector2

var intruder: Object
export var is_shooting: = false
export var striked: = false
export var dying: = false




func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	
	sprites()
	
	for collide in area_sight.get_overlapping_bodies():
		if collide.is_in_group("player"):
			check_cast_to(collide)
			if !is_shooting and !striked:
				is_shooting = true
				yield(get_tree().create_timer(0.85), "timeout")
				var bullet_shot: = bullet.instance()
				parent.add_child(bullet_shot)
				shooting(collide, bullet_shot)
				is_shooting = false


func shooting(objective, bullet_shot):
	if objective.is_in_group("player"):
		bullet_shot.set_global_position(global_position)
		bullet_shot.set_rotation_degrees(bullet_shot.get_angle_to(objective.global_position))
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
	if health > 0:
		if !anim.is_playing():
			anim.play("idle")
		elif is_shooting and !striked:
			anim.play("shoot")
		elif striked:
			anim.play("hurt")
	elif dying:
		anim.play("death")

func damage():
	if !striked:
		health = health - dmg_income
		striked = true
		print("Wizard get hit by ", dmg_income, " dmg, ", health, " health remaining")
		emit_signal("health_update", health)
	elif health > 0 and !dying:
		dying = true
		print("muriendo")

func _on_hurbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("atacks"):
		damage()


func _on_Monk_monk_dmg(dmg) -> void:
	pass # Replace with function body.


func _on_area_wizard_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	
	pass # Replace with function body.
