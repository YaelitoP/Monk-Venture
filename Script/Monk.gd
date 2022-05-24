extends KinematicBody2D

onready var coll: = $coll_monk
onready var anim: = $anim_monk
onready var anim_player: = $player_monk
export var speed: = 800
export var minspeed: = 100
export var fricction: = 1
export var acceleration: = 9
export var jumpheight: = 1000


onready var jump: float = ((2.0 * jumpheight) / jumptime) * -1.0
onready var jumpfall: float = ((-2.0 * jumpheight) / (jumptime * jumptime)) * -1.0
onready var grav: float = ((-2.0 * jumpheight) / (falltime * falltime)) * -1.0

var jumptime: = 0.4
var falltime: = 0.5

var dmg: = 20
var health: = 1000
var direction : = Vector2.ZERO
var motion: = 0


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
	if Input.is_action_pressed("Left"):
		direction.x = lerp(-minspeed, -speed, acceleration)
	elif Input.is_action_pressed("Right"):
		direction.x = lerp(minspeed, speed, acceleration)
	else:
		direction.x = lerp(direction.x, 0, fricction)
	return direction.x

func animations():
	atacks()
	if direction.x > 0 and Input.is_action_pressed("Right"):
		anim_player.play("walkR")
	elif direction.x < 0 and Input.is_action_pressed("Left"):
		anim_player.play("walkL")
	elif !atacks():
		anim_player.play("idle")

func jumping():
	direction.y += jump
	
func gravity():
	return jumpfall if jumping() else grav

func atacks():
	if Input.is_action_just_pressed("Attack"):
		anim_player.play("punch")
		return true
	elif Input.is_action_just_pressed("Specials"):
		anim_player.play("kick")
		return true
	else:
		return false
