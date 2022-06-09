extends KinematicBody2D

onready var coll: = $coll_monk
onready var anim: = $anim_monk
onready var anim_player: = $player_monk
onready var current_anim: String = $player_monk.get_current_animation()
onready var rayfloor: = $rayfloor
onready var floor_ray1: =  $rayfloor/floor_ray1
onready var floor_ray2: =  $rayfloor/floor_ray2
export var speed: = 800
export var minspeed: = 100
export var fricction: = 1
export var acceleration: = 9
export var jumpheight: = 1000

onready var jump: float = ((2.0 * jumpheight) / jumptime) * -1.0
onready var jumpfall: float = ((-2.0 * jumpheight) / (jumptime * jumptime)) * -1.0
onready var grav: float = ((-2.0 * jumpheight) / (falltime * falltime)) * -1.0

var jumptime: = 0.3
var falltime: = 0.5

var look_left: = Vector2(-1, 1)
var look_right: = Vector2(1, 1)

var dmg: = 20
var health: = 1000
var direction : = Vector2.ZERO
var motion: = 0
var anim_time: float
var on_air: bool
var is_atacking: bool

func _ready() -> void:
	pass 

func _physics_process(delta: float) -> void:
	direction.y = gravity() * delta
	direction.x = get_directions() * delta
	
	animations()
	if is_on_floor() and Input.is_action_just_pressed("Jump"):
		jumping()
	
	direction = move_and_slide(direction, Vector2.UP)
	


func get_directions():
	if !is_atacking or on_air:
		if Input.is_action_pressed("Left"):
			direction.x = lerp(-minspeed, -speed, acceleration)
			motion = -1
		elif Input.is_action_pressed("Right"):
			direction.x = lerp(minspeed, speed, acceleration)
			motion = 1
		else:
			direction.x = lerp(direction.x, 0, fricction)
	return direction.x

func animations():
	if (!anim_player.is_playing() or current_anim == "idle") and (Input.is_action_just_pressed("Attack") or Input.is_action_just_pressed("Specials")):
		atacks()
	elif !is_atacking and !is_on_floor():
		anim_player.play("Jump")
		anim_time = anim_player.get_current_animation_length()
		if floor_ray1.is_colliding() or floor_ray2.is_colliding():
			anim_player.play("idle")
		elif on_air and anim_time == 0:
			anim_player.play("falling")
	elif !is_atacking and motion >= 0 and Input.is_action_pressed("Right"):
		anim_player.play("walk")
	elif !is_atacking and motion <= 0 and Input.is_action_pressed("Left"):
		anim_player.play("walkL")
	elif !anim_player.is_playing():
		anim_player.play("idle")
		is_atacking = false


func jumping():
	direction.y += jump
	if current_anim == "Jump":
		on_air = true
	elif is_on_floor():
		on_air = false

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
