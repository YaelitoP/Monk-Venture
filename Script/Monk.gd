extends KinematicBody2D

onready var coll: = $coll_monk
onready var anim: = $anim_monk
onready var anim_player: = $player_monk
onready var current_anim: String = $player_monk.get_current_animation()
onready var rayfloor: = $rayfloor
onready var floor_ray1: =  $rayfloor/floor_ray1
onready var floor_ray2: =  $rayfloor/floor_ray2

export var maxspeed: = 400
export var minspeed: = 50
export var fricction: = 4
export var acceleration: = 2
export var jumpheight: = 1000

onready var jump: float = ((2.0 * jumpheight) / jumptime) * -1.0
onready var jumpfall: float = ((-2.0 * jumpheight) / (jumptime * jumptime)) * -1.0
onready var grav: float = ((-2.0 * jumpheight) / (falltime * falltime)) * -1.0

var jumptime: = 0.3
var falltime: = 0.5

var dmg: = 20
var health: = 1000
var direction : = Vector2.ZERO
var motion: = 0

var anim_time: float
var on_air: bool
var is_atacking: bool
var one_time: = false
var act_speed: = 0

func _ready() -> void:
	pass 

func _physics_process(delta: float) -> void:
	
	direction.y = gravity() * delta
	
	get_directions(delta)
	
	animations()
	
	if is_on_floor() and Input.is_action_just_pressed("Jump"):
		jumping()
	
	direction = move_and_slide(direction, Vector2.UP)
	

func get_directions(delta):
	if !is_atacking or on_air:
		
		if Input.is_action_pressed("Left") and direction.x > -maxspeed:
			direction.x += lerp(direction.x, -maxspeed, acceleration) * delta
			motion = -1
		elif Input.is_action_pressed("Right") and direction.x < maxspeed:
			direction.x += lerp(direction.x, maxspeed, acceleration) * delta
			motion = 1
		elif direction.x < 0:
			direction.x += lerp(direction.x, 0, fricction) * delta
			motion = 0
		elif direction.x > 0:
			direction.x += lerp(direction.x, 0, fricction) * delta
			motion = 0
	elif direction.x < 0:
		direction.x += lerp(direction.x, 0, fricction) * delta
	elif direction.x > 0:
		direction.x += lerp(direction.x, 0, fricction) * delta

func animations():
	if (!anim_player.is_playing() or current_anim == "idle") and (Input.is_action_just_pressed("Attack") or Input.is_action_just_pressed("Specials")):
		atacks()
	elif !is_atacking and on_air and !one_time:
		anim_player.play("Jump")
		anim_player.advance(0)
		one_time = true
		if floor_ray1.is_colliding() or floor_ray2.is_colliding():
			anim_player.play("idle")
	elif !is_atacking and motion == 1 and !on_air:
		anim_player.play("walk")
	elif !is_atacking and motion == -1 and !on_air:
		anim_player.play("walkL")
	elif !anim_player.is_playing():
		anim_player.play("idle")
		one_time = false
		is_atacking = false

func jumping():
	direction.y += jump
	if is_on_floor() or floor_ray1.is_colliding() or floor_ray2.is_colliding():
		on_air = false
	else:
		on_air = true

func gravity():
	return jumpfall if jumping() else grav

func atacks():
	if !is_atacking and Input.is_action_just_pressed("Attack") and motion >= 0:
		anim_player.play("punchLeft")
		anim_time = anim_player.get_current_animation_length()
		is_atacking = true
	elif !is_atacking and Input.is_action_just_pressed("Attack") and motion <= 0:
		anim_player.play("punch")
		anim_time = anim_player.get_current_animation_length()
		is_atacking = true
	elif !is_atacking and Input.is_action_just_pressed("Specials") and motion >= 0:
		anim_player.play("kickleft")
		anim_time = anim_player.get_current_animation_length()
		is_atacking = true
	elif !is_atacking and Input.is_action_just_pressed("Specials") and motion <= 0:
		anim_player.play("kick")
		anim_time = anim_player.get_current_animation_length()
		is_atacking = true
	elif anim_time == 0:
		is_atacking = false
