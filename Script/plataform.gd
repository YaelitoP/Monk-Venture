tool
extends KinematicBody2D

onready var waypoints: = get_node(waypoints_path)

export var editor_process: = true setget set_editor_process

export var speed: = 400.0

export var waypoints_path: = NodePath()

var target_position: = Vector2()


func _ready() -> void:
	
	if not waypoints:
		
		set_physics_process(false)
		return
		
	position = waypoints.get_start_position()
	
	target_position = waypoints.get_next_point_position()


func _physics_process(delta: float) -> void:
	
	var direction: = (target_position - global_position).normalized()
	
	var motion: = direction * speed * delta
	
	var distance_to_target: = global_position.distance_to(target_position)
	
	if motion.length() > distance_to_target:
		global_position = target_position
		target_position = waypoints.get_next_point_position()
		set_physics_process(false)
		yield(get_tree().create_timer(1.0), "timeout")
		set_physics_process(true)
	else:
		global_position += motion




func set_editor_process(value:bool) -> void:
	editor_process = value
	if not Engine.editor_hint:
		return
	set_physics_process(value)








