extends KinematicBody2D
class_name monkCharacter

signal monk_dmg(dmg)
signal health_change(health)
signal death()





onready var coll: = $coll_monk
onready var anim: = $anim_monk
onready var anim_player: = $player_monk
onready var dmg_box: = $area_atacks
onready var current_anim: String = $player_monk.get_current_animation()
onready var rayfloor: = $rayfloor
onready var floor_ray1: =  $rayfloor/floor_ray1
onready var floor_ray2: =  $rayfloor/floor_ray2

export var maxspeed: = 400
export var minspeed: = 50
export var fricction: = 5
export var acceleration: = 2
export var jumpheight: = 80

onready var jump: float = ((2.0 * jumpheight) / jumptime) * -1.0
onready var jumpfall: float = ((-2.0 * jumpheight) / (jumptime * jumptime)) * -1.0
onready var grav: float = ((-2.0 * jumpheight) / (falltime * falltime)) * -1.0

var jumptime: = 0.4
var falltime: = 0.5

var dmg: = 20 setget set_dmg
var health: = 1000
var direction : = Vector2.ZERO
var motion: = 0

var anim_time: float
var on_air: bool
var is_atacking: bool
var one_time: = false

func _ready() -> void:
	pass 

func _physics_process(delta: float) -> void:
	
	direction.y += gravity() * delta
	
	if !is_atacking or on_air:
		get_directions(delta)
	else:
		direction.x = 0
	
	animations()
	
	if is_on_floor() and Input.is_action_just_pressed("Jump"):
		jumping()
	
	direction = move_and_slide(direction, Vector2.UP)
	

func get_directions(delta):
	
		if Input.is_action_pressed("Left") and direction.x >= -maxspeed:
			direction.x += lerp(direction.x, -maxspeed, acceleration) * delta
			motion = -1
		elif Input.is_action_pressed("Right") and direction.x <= maxspeed:
			direction.x += lerp(direction.x, maxspeed, acceleration) * delta
			motion = 1
		elif Input.is_action_pressed("Right") and direction.x == maxspeed:
			direction.x = maxspeed * delta
		elif Input.is_action_pressed("Left") and direction.x == -maxspeed:
			direction.x = -maxspeed * delta
		elif on_air and Input.is_action_just_pressed("Jump"):
			direction.x += lerp(direction.x, 0, grav) * delta
		elif direction.x < -25 or direction.x > 25:
			direction.x += lerp(direction.x, 0, fricction) * delta
		else:
			direction.x = 0

func animations():
	
	if !is_atacking and on_air and !one_time:
		anim_player.play("Jump")
		one_time = true
		if floor_ray1.is_colliding() or floor_ray2.is_colliding():
			anim_player.play("idle")
			one_time = false
	elif !is_atacking and Input.is_action_pressed("Right") and is_on_floor():
		anim_player.play("walk")
		one_time = false
	elif !is_atacking and Input.is_action_pressed("Left") and is_on_floor():
		anim_player.play("walkL")
		one_time = false
	elif !is_atacking and direction.x == 0 and is_on_floor():
		anim_player.play("idle")
		one_time = false
		is_atacking = false

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
	elif !anim_player.is_playing():
		is_atacking = false
		one_time = false

func jumping():
	
	
	direction.y += jump
	if is_on_floor() or floor_ray1.is_colliding() or floor_ray2.is_colliding():
		on_air = false
	else:
		on_air = true

func gravity():
	return jumpfall if jumping() else grav

func set_dmg(new_dmg):
	dmg = new_dmg


func _on_area_atacks_body_entered(body: Node) -> void:
	emit_signal("monk_dmg", dmg)


func _on_area_atacks_area_entered(area: Area2D) -> void:
	emit_signal("monk_dmg", dmg)
