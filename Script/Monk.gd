extends KinematicBody2D
class_name monkCharacter


onready var coll: = $coll_monk
onready var sprite: = $anim_monk
onready var effects: = $effects
onready var anim_player: = $player_monk
onready var hurtbox: = $hurtbox
onready var coll_hurt: = $hurtbox/coll_hurt
onready var dmg_box: = $area_atacks
onready var control: = $Control
onready var rayfloor: = $rayfloor
onready var floor_ray1: =  $rayfloor/floor_ray1
onready var floor_ray2: =  $rayfloor/floor_ray2
onready var timer: = $cooldown

const DASH_LIMIT: = 400


export var maxspeed: = 240
export var minspeed: = 50
export var fricction: = 5
export var acceleration: = 2.5

export var dash: = true
export var dobleJump: = false
export var on_air: bool

export var available_dash: = 2
export var available_jumps: = 2
export var jumpheight: = 120

export var dashed: = false

onready var jump: float = ((2.0 * jumpheight) / jumptime) * -1.0


onready var jumpfall: float = ((-2.0 * jumpheight) / (jumptime * jumptime)) * -1.0


onready var grav: float = ((-2.0 * jumpheight) / (falltime * falltime)) * -1.0


var jumptime: = 0.4
var falltime: = 0.5
var cooldown: = false

var force: = 0 setget ,get_force
var dmg: = 20 setget set_dmg, get_dmg


export var health: = 150
export var dmg_income: = 25
export var direction: Vector2 = Vector2.ZERO


var motion: = 0


export var atacking: bool
export var crounched: bool


export var death: = false
export var hurted: = false


var moving = false


func _ready() -> void:
	sprite.flip_h = true
	death = false
	hurted = false


func _physics_process(delta: float) -> void:
	
	if !death and !hurted:
		
		if Input.is_action_pressed("Left"):
			motion = -1
			
		elif Input.is_action_pressed("Right"):
			motion = 1
		
		direction.y += gravity() * delta
		
		jumping()
		animations()
		dashing()
		
		if !atacking and !on_air and !dashed:
			get_directions(delta)
				
		elif !moving or on_air:
			direction.x += lerp(direction.x, 0, fricction/3) * delta
		elif dashed:
			direction.x += lerp(direction.x, 0, fricction/2) * delta
			
	if !death:
		direction = move_and_slide(direction, Vector2.UP)
	



func get_directions(delta):
	
	if Input.is_action_pressed("Left") and direction.x >= -maxspeed and !crounched:
		
		direction.x += lerp(direction.x, -maxspeed, acceleration) * delta
		moving = true
		
	elif Input.is_action_pressed("Right") and direction.x <= maxspeed and !crounched:
		
		direction.x += lerp(direction.x, maxspeed, acceleration) * delta
		moving = true
		
	elif Input.is_action_pressed("Down"):
		direction.x += lerp(direction.x, 0, fricction) * delta
		
	elif !moving and !is_on_floor():
		direction.x += lerp(direction.x, 0, fricction) * delta
		
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




func dashing():
	
	if Input.is_action_just_pressed("Run") and available_dash != 0 and !atacking:
		dashed = true
		if on_air or atacking:
			
			if motion == 1:
				direction.x += lerp(direction.x, maxspeed, acceleration)
				available_dash = available_dash - 1
				
				
			if motion == -1:
				direction.x += lerp(direction.x, -maxspeed, acceleration)
				available_dash = available_dash - 1
			
		else:
			
			if motion == 1:
				direction.x += clamp(lerp(direction.x, maxspeed * 2, acceleration * 5), 0, DASH_LIMIT)
				available_dash = available_dash - 1
			
			if motion == -1:
				direction.x += clamp(lerp(direction.x, -maxspeed * 2, acceleration * 5), -DASH_LIMIT, 0)
				available_dash = available_dash - 1
			
	if available_dash != 2 and !cooldown:
		timer.start()
		cooldown = true
		
	elif timer.time_left == 0 and cooldown:
		available_dash = available_dash + 1
		cooldown = false
		
	




func animations():
	
	if !dashed:
		
		if !atacking:
			
			if Input.is_action_just_pressed("Jump") and available_jumps == 1:
				anim_player.play("Jump")
				crounched = false
				
			elif dobleJump and Input.is_action_just_pressed("Jump") and available_jumps == 0:
				anim_player.play("dobleJump")
				
			if !on_air:
				
				if !crounched:
					
					if  Input.is_action_pressed("Right") and moving:
						anim_player.play("walkL")
						force = 100
						
					if Input.is_action_pressed("Left") and moving:
						anim_player.play("walk")
						force = -100
						
				if Input.is_action_pressed("Down"):
					anim_player.play("crounch")
					crounched = true
					moving = false
				
			if crounched and Input.is_action_just_pressed("Specials"):
				anim_player.play("crounchKick")
				atacking = true
				moving = false
				
			elif direction.x == 0 and !on_air and !crounched:
				anim_player.play("idle")
				available_jumps = 2
	else:
		if on_air:
			if motion == 1:
				anim_player.play("dashAereo")
				crounched = false
				
			if motion == -1:
				anim_player.play("dashAereoLeft")
				crounched = false
		else:
			if motion == 1:
				anim_player.play("dash")
				crounched = false
				
			if motion == -1:
				anim_player.play("dashleft")
				crounched = false
				
	if !crounched:
		
		if !atacking:
			
			if Input.is_action_just_pressed("Attack") and motion <= 0:
				anim_player.play("punchLeft")
				force = -100
				atacking = true
				moving = false
				
			elif Input.is_action_just_pressed("Attack") and motion >= 0:
				anim_player.play("punch")
				force = 100
				atacking = true
				moving = false
				
			elif Input.is_action_just_pressed("Specials") and motion <= 0:
				anim_player.play("kickleft")
				force = -100
				atacking = true
				moving = false
				
			elif Input.is_action_just_pressed("Specials") and motion >= 0:
				anim_player.play("kick")
				force = 100
				atacking = true
				moving = false
				
	if !anim_player.is_playing():
		atacking = false
		crounched = false
	







func jumping():
	
	if Input.is_action_just_pressed("Jump"):
		on_air = true
		
		if available_jumps == 2:
			direction.y += jump
			available_jumps = 1
			
		elif dobleJump and available_jumps == 1:
			direction.y = 0
			direction.y += jump
			available_jumps = 0
			
	elif is_on_floor() and (floor_ray1.is_colliding() or floor_ray2.is_colliding()):
		on_air = false
		available_jumps = 2
	





func gravity():
	return jumpfall if available_jumps != 2 else grav




func set_dmg(new_dmg):
	dmg = new_dmg




func get_dmg():
	return dmg



func pickUp():
	if Input.is_action_just_pressed("Interactive"):
		dobleJump = true



func was_hurted(collide):
	hurted = true
	crounched = false
	moving = false
	atacking = false
	if collide.is_in_group("bullets"):
		direction.x += collide.get_applied_force().x / 15
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


func get_force():
	return force
	

func _on_hurtbox_area_entered(area: Area2D) -> void:
	
	if area.get_collision_layer() == 8:
		control.set_visible(true)
		pickUp()


func _on_hurtbox_area_exited(area: Area2D) -> void:
	
	if area.get_collision_layer() == 8:
		control.set_visible(false)


