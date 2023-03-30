extends KinematicBody2D
class_name monkCharacter

const DASH_LIMIT: = 300

onready var parent: Node = get_parent()
onready var coll: Node = $coll_monk
onready var sprite: Node = $anim_monk
onready var effects: Node = $effects
onready var anim_player: Node = $player_monk
onready var hurtbox: Node = $hurtbox
onready var coll_hurt: Node = $hurtbox/coll_hurt
onready var dmg_box:Node = $area_atacks
onready var control: Node = $Control
onready var rayfloor: Node = $rayfloor
onready var floor_ray1:Node =  $rayfloor/floor_ray1
onready var floor_ray2: Node =  $rayfloor/floor_ray2
onready var timer: Node = $cooldown
onready var invencible: Node = $invencible

export var maxspeed: int = 300
export var minspeed: int = 50
export var fricction: int = 6
export var acceleration: int = 4


export var dobleJump: bool = false
export var on_air: bool

export var dashed: bool = false

export var health: int = 150
export var dmg_income: int = 25
export var direction: Vector2 = Vector2.ZERO

export var atacking: bool
export var crounched: bool

export var death: bool = false
export var hurted: bool = false

export var available_dash: int = 2
export var available_jumps: int = 2
export var jumpheight: int = 150

onready var jump: float = ((2.0 * jumpheight) / jumptime) * -1.0

onready var jumpfall: float = ((-2.0 * jumpheight) / (jumptime * jumptime)) * -1.0

onready var grav: float = ((-2.0 * jumpheight) / (falltime * falltime)) * -1.0

var jumptime: float = 0.4
var falltime: float = 0.5
var cooldown: bool = false

var inertia:bool = false
var force: int = 0 setget ,get_force
var dmg: int = 20 setget set_dmg, get_dmg

var motion: int = 0

var left: bool = false
var right: bool = true
var moving:bool = false


func _ready() -> void:
	sprite.flip_h = true
	death = false
	hurted = false


func _physics_process(delta: float) -> void:
	if health <= 0:
		death = true
		anim_player.play("death")
	if invencible.time_left !=0:
		set_collision_layer_bit(0, false)
		hurtbox.set_collision_mask_bit(0, false)
		hurtbox.set_collision_mask_bit(2, false)
	else:
		set_collision_layer_bit(0, true)
		hurtbox.set_collision_mask_bit(0, true)
		hurtbox.set_collision_mask_bit(2, true)
	
	if !death:
		if !hurted or invencible.time_left != 0:
			for collide in hurtbox.get_overlapping_areas():
				if collide.is_in_group("traps"):
					was_hurted(collide)
				if collide.is_in_group("pickup"):
					control.set_visible(true)
					pickUp(collide)
				if collide.is_in_group("exit"):
					control.set_visible(true)
					pickUp(collide)
				
			direction.y += gravity() * delta
			
			jumping()
			animations()
			dashing()
			
			if !atacking and !dashed:
				if Input.is_action_pressed("Left"):
					left = true
					right = false
				
				if Input.is_action_pressed("Right"):
					left = false
					right = true
					
				get_directions(delta)
				
				
			if !moving and on_air:
				direction.x += lerp(direction.x, 0, fricction/2) * delta
				
			elif on_air:
				direction.x += lerp(direction.x, 0, fricction/4) * delta
				
			elif dashed and !moving:
				direction.x += lerp(direction.x, 0, fricction/2) * delta
			
		else:
			hurted = false
		direction = move_and_slide(direction, Vector2.UP, false, 4, 0.785398, inertia)
		




func get_directions(delta):
	if !hurted:
		if Input.is_action_pressed("Left") and direction.x >= -maxspeed and !crounched:
			
			direction.x += lerp(direction.x, -maxspeed, acceleration) * delta
			moving = true
			inertia = false
		elif Input.is_action_pressed("Right") and direction.x <= maxspeed and !crounched:
			inertia = false
			direction.x += lerp(direction.x, maxspeed, acceleration) * delta
			moving = true
		
		elif Input.is_action_pressed("Down"):
			direction.x += lerp(direction.x, 0, fricction) * delta
			inertia = false
			
		elif !Input.is_action_pressed("Left") and !Input.is_action_pressed("Right"):
			direction.x += lerp(direction.x, 0, fricction) * delta
			moving = false
			inertia = false
	else:
		inertia = false
		direction.x = 0
		moving = false
		
	if Input.is_action_just_released("Right") and left == true:
		moving = false
		right = false
		
	if Input.is_action_just_released("Left") and right == true:
		moving = false
		left = false
		
	if Input.is_action_just_released("Down"):
		crounched = false




func dashing():
	parent.emit_signal("dash_status", timer.time_left, available_dash)
	
	if Input.is_action_just_pressed("Run") and available_dash != 0 and !atacking:
		dashed = true
		
		if on_air:
			
			if right:
				
				direction.x += lerp(direction.x, DASH_LIMIT, acceleration / 2)
				inertia = true
				available_dash = available_dash - 1
				
				
			if left:
				
				direction.x += lerp(direction.x, -DASH_LIMIT, acceleration / 2)
				inertia = true
				available_dash = available_dash - 1
			
		else:
			
			if right:
				
				direction.x += clamp(lerp(direction.x, DASH_LIMIT, acceleration), direction.x, DASH_LIMIT)
				available_dash = available_dash - 1
				inertia = true
			
			if left:
				direction.x += clamp(lerp(direction.x, -DASH_LIMIT, acceleration), -DASH_LIMIT, direction.x)
				available_dash = available_dash - 1
				inertia = true
			
	if available_dash != 2 and !cooldown:
		timer.start()
		cooldown = true
		
	elif timer.time_left == 0 and cooldown:
		available_dash = available_dash + 1
		cooldown = false
		
	




func animations():
	if hurted:
		anim_player.play("hurt")
	else:
		if !dashed:
		
			if !atacking:
				if !is_on_floor() and !(direction.y < 0):
					anim_player.play("falling")
				if !on_air:
					if !crounched:
						if  Input.is_action_pressed("Right") and moving:
							anim_player.play("walkL")
							force = 100
							
						if Input.is_action_pressed("Left") and moving:
							anim_player.play("walk")
							force = -100
						
						if !moving:
							anim_player.play("idle")
						
					if Input.is_action_pressed("Down"):
						anim_player.play("crounch")
						crounched = true
						moving = false
				
				if crounched and Input.is_action_just_pressed("Specials"):
					anim_player.play("crounchKick")
					atacking = true
					moving = false
				
				if Input.is_action_just_pressed("Jump") and available_jumps == 1:
					anim_player.play("Jump")
					crounched = false
					
				elif dobleJump and Input.is_action_just_pressed("Jump") and available_jumps == 0:
					anim_player.play("dobleJump")
					
		elif dashed:
			if on_air:
				if right:
					anim_player.play("dashAereo")
					crounched = false
					
				if left:
					anim_player.play("dashAereoLeft")
					crounched = false
			else:
				if right:
					anim_player.play("dash")
					crounched = false
					
				if left:
					anim_player.play("dashleft")
					crounched = false
				
		
		if !crounched:
			
			if !atacking:
				
				if Input.is_action_just_pressed("Attack") and left:
					anim_player.play("punchLeft")
					force = -100
					atacking = true
					moving = false
					
				elif Input.is_action_just_pressed("Attack") and right:
					anim_player.play("punch")
					force = 100
					atacking = true
					moving = false
					
				elif Input.is_action_just_pressed("Specials") and left:
					anim_player.play("kickleft")
					force = -100
					atacking = true
					moving = false
					
				elif Input.is_action_just_pressed("Specials") and right:
					anim_player.play("kick")
					force = 100
					atacking = true
					moving = false
	
	if !anim_player.is_playing():
		anim_player.play("idle")
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
	



func pickUp(collide):
	if Input.is_action_just_pressed("Interactive") and collide.name == "doblejump":
		dobleJump = true
	

func was_hurted(collide):
	if collide.is_in_group("bullets") and invencible.time_left == 0:
		hurted = true
		direction.x += collide.get_applied_force().x / 10
		health = health - dmg_income
		invencible.start()
		crounched = false
		moving = false
		atacking = false
	if collide.is_in_group("traps") and invencible.time_left == 0:
		hurted = true
		health = health - dmg_income
		invencible.start()
		crounched = false
		moving = false
		atacking = false
	if collide.is_in_group("mobs") and invencible.time_left == 0:
		hurted = true
		health = health - dmg_income
		invencible.start()
		crounched = false
		moving = false
		atacking = false
	if health <= 0:
		death = true
		anim_player.play("death")


func _on_hurtbox_body_entered(body: Node) -> void:
	direction.x = 0
	if body.is_in_group("bullets"):
		was_hurted(body)
	if body.is_in_group("mobs"):
		was_hurted(body)
		
func get_force():
	return force
	

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("traps"):
		was_hurted(area)

func _on_hurtbox_area_exited(_area: Area2D) -> void:
	control.set_visible(false)


func gravity():
	return jumpfall if available_jumps != 2 else grav


func set_dmg(new_dmg):
	dmg = new_dmg


func get_dmg():
	return dmg
