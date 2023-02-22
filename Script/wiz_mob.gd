extends RigidBody2D
class_name wizard

onready var anim: = $anim_wizard
onready var sprites: = $anim_sprites
onready var area_sight: = $area_wizard
onready var coll: = $coll_wizard
onready var aiming: = $aiming
onready var hurtbox: = $hurtbox
onready var coll_hurt: = $hurtbox/coll_hurtbox
onready var aim0: = $aiming/aim1
onready var aim1: = $aiming/aim2
onready var aim2: = $aiming/aim3
onready var shot_speed: = $shot_speed

onready var bullet: = preload("res://tscn/Mobs/wispy.tscn")

onready var parent: = get_parent()

onready var collision0: Node
onready var collision1: Node
onready var collision2: Node
onready var knockback: = 0
onready var striked: = false
onready var collided_player: = []
export var shoot: = false

export var is_shooting: = false
export var dying: = false

export var health: = 100 setget set_health, get_health
export var max_health: = 200

export var sight: = 200
var intruder_pos: Vector2
var bullet_speed: = 2000
var angle_shot: = Vector2.ZERO


func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	
	play_sprites()
	
	for collide in area_sight.get_overlapping_bodies():
		if collide.is_in_group("player"):
			check_cast_to(collide)
			knockback = collide.get_force()
			if intruder_pos > self.position:
				sprites.flip_h = true
			else:
				sprites.flip_h = false
				
			if collided_player.has(true) and !striked:
				is_shooting = true
				
				if shoot:
						var bullet_shot: = bullet.instance()
						parent.add_child(bullet_shot)
						shooting(collide, bullet_shot)
						is_shooting = false
			else:
				is_shooting = false

func shooting(objective, bullet_shot):
	bullet_shot.set_global_position(global_position)
	bullet_shot.set_rotation_degrees(bullet_shot.get_angle_to(objective.global_position))
	bullet_shot.add_force(Vector2.ZERO, Vector2(bullet_speed, 0).rotated(aim1.get_cast_to().angle()))
	


func check_cast_to(collide):
	intruder_pos = global_position.direction_to(collide.get_global_position()) * sight
	
	aim0.set_cast_to(intruder_pos)
	aim1.set_cast_to(intruder_pos)
	aim2.set_cast_to(intruder_pos)
	
	if (aim0.is_colliding()) or aim1.is_colliding() or aim2.is_colliding():
		if aim0.is_colliding():
			collision0 = aim0.get_collider()
			collided_with()
			
		if aim1.is_colliding():
			collision1 = aim1.get_collider()
			collided_with()
			
		if aim2.is_colliding():
			collision2 = aim2.get_collider()
			collided_with()
	else:
		collided_player.clear()
	
	if !aim0.is_colliding():
		collision0 = null
		collided_player.pop_back()
		
	if !aim1.is_colliding():
		collision1 = null
		collided_player.pop_back()
		
	if !aim2.is_colliding():
		collision2 = null
		collided_player.pop_back()


func collided_with():
	if collision0 != null:
		if collision0.is_in_group("player"):
			collided_player.append(true)
	if collision1 != null:
		if collision1.is_in_group("player"):
			collided_player.append(true)
	if collision2 != null:
		if collision2.is_in_group("player"):
			collided_player.append(true)
	

func play_sprites():
	if health > 0:
		if !anim.is_playing():
			anim.play("idle")
		elif is_shooting and !striked:
			anim.play("shoot")
		elif striked:
			anim.play("hurt")
	elif health <= 0:
		anim.play("death")
	

func damage(dmg_income):
	if !striked:
		health = health - dmg_income
		striked = true
		self.apply_impulse(Vector2.ZERO, Vector2(knockback * 100, 0))
		print("Wizard get hit by ", dmg_income, " dmg, ", health, " health remaining")
	

func set_health(new_health):
	health = new_health

func get_health():
	return health



