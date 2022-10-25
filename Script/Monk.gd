extends KinematicBody2D
class_name monkCharacter

onready var coll: = $coll_monk
onready var sprite: = $anim_monk
onready var anim_player: = $player_monk

onready var dmg_box: = $area_atacks

onready var rayfloor: = $rayfloor
onready var floor_ray1: =  $rayfloor/floor_ray1
onready var floor_ray2: =  $rayfloor/floor_ray2

export var maxspeed: = 400
export var minspeed: = 50
export var fricction: = 5
export var acceleration: = 2

export var jumpheight: = 120
onready var jump: float = ((2.0 * jumpheight) / jumptime) * -1.0
onready var jumpfall: float = ((-2.0 * jumpheight) / (jumptime * jumptime)) * -1.0
onready var grav: float = ((-2.0 * jumpheight) / (falltime * falltime)) * -1.0

var jumptime: = 0.4
var falltime: = 0.5

var dmg: = 20 setget set_dmg, get_dmg

export var health: = 150
export var dmg_income: = 25
var direction : = Vector2.ZERO
var motion: = 0

var anim_time: float

var on_air: bool
var is_atacking: bool

export var death: = false
export var hurted: = false
var one_time: = false
var moving = false

func _ready() -> void:
	sprite.flip_h = true
	death = false
	hurted = false
 

func _physics_process(delta: float) -> void:
	if !death and !hurted:
		direction.y += gravity() * delta
		if !one_time:
			jumping()
		
		if !is_atacking or on_air:
			get_directions(delta)
		else:
			direction.x = 0
		
		animations()
	if !death:
		direction = move_and_slide(direction, Vector2.UP)
		
func get_directions(delta):
	if Input.is_action_pressed("Left") and direction.x >= -maxspeed and !is_atacking:
		direction.x += lerp(direction.x, -maxspeed, acceleration) * delta
		motion = -1
		moving = true
		
	elif Input.is_action_pressed("Right") and direction.x <= maxspeed and !is_atacking:
		direction.x += lerp(direction.x, maxspeed, acceleration) * delta
		motion = 1
		moving = true
		
	elif on_air and !moving and Input.is_action_just_pressed("Jump") and !one_time:
		direction.x += lerp(direction.x, 0, grav) * delta
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

func animations():
	
	if !is_atacking and on_air and !one_time:
		anim_player.play("Jump")
		one_time = true
		if is_on_floor() or (floor_ray1.is_colliding() or floor_ray2.is_colliding()):
			anim_player.play("idle")
			one_time = false
	
	if !is_atacking and Input.is_action_pressed("Right") and is_on_floor():
		anim_player.play("walk")
		one_time = false
	
	if !is_atacking and Input.is_action_pressed("Left") and is_on_floor():
		anim_player.play("walkL")
		one_time = false
	
	elif !is_atacking and direction.x == 0 and is_on_floor():
		anim_player.play("idle")
		one_time = false
		is_atacking = false
		
	if !is_atacking and Input.is_action_just_pressed("Attack") and motion <= 0:
		anim_player.play("punchLeft")
		is_atacking = true
	
	elif !is_atacking and Input.is_action_just_pressed("Attack") and motion >= 0:
		anim_player.play("punch")
		is_atacking = true
	
	elif !is_atacking and Input.is_action_just_pressed("Specials") and motion <= 0:
		anim_player.play("kickleft")
		is_atacking = true
	
	elif !is_atacking and Input.is_action_just_pressed("Specials") and motion >= 0:
		anim_player.play("kick")
		is_atacking = true
	
	elif !anim_player.is_playing():
		is_atacking = false
		one_time = false

func jumping():
	if Input.is_action_just_pressed("Jump") and !one_time:
		direction.y += jump
	
	if (floor_ray1.is_colliding() or floor_ray2.is_colliding()):
		on_air = false
	else:
		on_air = true

func gravity():
	return jumpfall if on_air else grav

func set_dmg(new_dmg):
	dmg = new_dmg

func get_dmg():
	return dmg

func was_hurted():
	anim_player.play("hurt")
	hurted = true
	direction.x = -motion * 80
	health = health - dmg_income
	if health <= 0:
		death = true
		anim_player.play("death")
	return true
	


func _on_hurtbox_body_entered(body: Node) -> void:
	if body.is_in_group("bullets"):
		was_hurted()
		print("auch")
