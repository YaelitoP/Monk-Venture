extends KinematicBody2D
class_name monkCharacter

onready var coll: = $coll_monk
onready var sprite: = $anim_monk
onready var anim_player: = $player_monk
onready var hurtbox: = $hurtbox
onready var coll_hurt: = $hurtbox/coll_hurt
onready var dmg_box: = $area_atacks
onready var control: = $Control
onready var rayfloor: = $rayfloor
onready var floor_ray1: =  $rayfloor/floor_ray1
onready var floor_ray2: =  $rayfloor/floor_ray2


export var maxspeed: = 400
export var minspeed: = 50
export var fricction: = 5
export var acceleration: = 2

export var jumpheight: = 120


export var dobleJump: = false

onready var force: = 0 setget , get_force

onready var jump: float = ((2.0 * jumpheight) / jumptime) * -1.0

onready var jumpfall: float = ((-2.0 * jumpheight) / (jumptime * jumptime)) * -1.0

onready var grav: float = ((-2.0 * jumpheight) / (falltime * falltime)) * -1.0

var jumptime: = 0.4
var falltime: = 0.5

var dmg: = 20 setget set_dmg, get_dmg

export var health: = 10000
export var dmg_income: = 25
export var direction: Vector2 = Vector2.ZERO


var motion: = 0

var anim_time: float

var on_air: bool
var is_atacking: bool
var crounched: bool

export var death: = false
export var hurted: = false

var available_jumps: = 2
var moving = false



func _ready() -> void:
	sprite.flip_h = true
	death = false
	hurted = false
 

func _physics_process(delta: float) -> void:
	if !death and !hurted:
		direction.y += gravity() * delta
		animations()
		jumping()
		
		if !is_atacking and !on_air:
			get_directions(delta)
		else:
			direction.x += lerp(direction.x, 0, fricction) * delta
		
	if !death:
		direction = move_and_slide(direction, Vector2.UP)
	


func get_directions(delta):
	if Input.is_action_pressed("Left") and direction.x >= -maxspeed and !crounched:
		direction.x += lerp(direction.x, -maxspeed, acceleration) * delta
		motion = -1
		moving = true
		
	elif Input.is_action_pressed("Right") and direction.x <= maxspeed and !crounched:
		direction.x += lerp(direction.x, maxspeed, acceleration) * delta
		motion = 1
		moving = true
		
	elif Input.is_action_pressed("Down"):
		direction.x += lerp(direction.x, 0, fricction) * delta
		
	elif !moving and !is_on_floor():
		direction.x += lerp(direction.x, 0, fricction) * delta
		motion = 0
		
	elif direction.x < -25 or direction.x > 25:
		direction.x += lerp(direction.x, 0, fricction) * delta
		
	else:
		direction.x = 0
		moving = false
		
	if Input.is_action_just_released("Right"):
		moving = false
	if Input.is_action_just_released("Left"):
		moving = false
	if Input.is_action_just_released("Down"):
		crounched = false

func animations():
	
	if !is_atacking:
		
		if Input.is_action_just_pressed("Jump"):
			on_air = true
			anim_player.play("Jump")
			available_jumps = 1
			
			
			if dobleJump and Input.is_action_just_pressed("Jump") and available_jumps == 1 and on_air:
				available_jumps = 0
				anim_player.play("dobleJump")
				
				
			if is_on_floor() or (floor_ray1.is_colliding() or floor_ray2.is_colliding()):
				on_air = false
				anim_player.play("idle")
				#available_jumps = 2
				crounched = false
				

		elif is_on_floor():
			
			if  Input.is_action_pressed("Right") and !crounched:
				anim_player.play("walkL")
				force = 100
				available_jumps = 2
			
			
			if Input.is_action_pressed("Left") and !crounched:
				anim_player.play("walk")
				force = -100
				available_jumps = 2
			
			
			elif Input.is_action_pressed("Down"):
				anim_player.play("crounch")
				crounched = true
			
			
		if !is_atacking and crounched and Input.is_action_just_pressed("Specials"):
			anim_player.play("crounchKick")
			is_atacking = true
			
			
		elif !is_atacking and direction.x == 0 and is_on_floor() and !crounched:
			anim_player.play("idle")
			available_jumps = 2
			is_atacking = false
			
		
		
	if !is_atacking and Input.is_action_just_pressed("Attack") and motion <= 0 and !crounched:
		anim_player.play("punchLeft")
		force = -100
		is_atacking = true
	
	
	elif !is_atacking and Input.is_action_just_pressed("Attack") and motion >= 0 and !crounched:
		anim_player.play("punch")
		force = 100
		is_atacking = true
	
	
	
	elif !is_atacking and Input.is_action_just_pressed("Specials") and motion <= 0 and !crounched:
		anim_player.play("kickleft")
		force = -100
		is_atacking = true
	
	
	
	elif !is_atacking and Input.is_action_just_pressed("Specials") and motion >= 0 and !crounched:
		anim_player.play("kick")
		force = 100
		is_atacking = true
	
	
	
	elif !anim_player.is_playing():
		is_atacking = false
		crounched = false


func jumping():
	if Input.is_action_just_pressed("Jump"):
		on_air = true
		if available_jumps == 2:
			direction.y += jump
			available_jumps = 1
			
		elif dobleJump and available_jumps == 1:
			available_jumps = 0
			direction.y = 0
			direction.y += jump
	elif is_on_floor():
		#available_jumps = 2
		on_air = false

func gravity():
	return jumpfall if available_jumps != 2 else grav



func set_dmg(new_dmg):
	dmg = new_dmg



func get_dmg():
	return dmg



func was_hurted(collide):
	hurted = true
	if collide.is_in_group("bullets"):
		direction.x += collide.get_applied_force().x / 10
	health = health - dmg_income
	anim_player.play("hurt")
	if health <= 0:
		death = true
		anim_player.play("death")
	return true
	



func _on_hurtbox_body_entered(body: Node) -> void:
	direction.x = 0
	if body.is_in_group("bullets"):
		was_hurted(body)
		print("auch")
		

func get_force():
	return force


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.get_collision_layer() == 8:
		control.set_visible(true)


func _on_hurtbox_area_exited(area: Area2D) -> void:
	if area.get_collision_layer() == 8:
		control.set_visible(false)


