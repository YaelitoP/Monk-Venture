extends Node2D


export var editor_process: = true setget set_editor_process

var _active_point_index: = 0

func _ready() -> void:
	
	if not Engine.editor_hint:
		set_process(false)
	


func _process(delta: float) -> void:
	update()


func get_start_position() -> Vector2:
	return get_child(0).global_position
	


func get_current_point_position() -> Vector2:
	return get_child(_active_point_index).global_position
	


func get_next_point_position():
	_active_point_index = (_active_point_index + 1) % get_child_count()
	return get_current_point_position()
	

func set_editor_process(value:bool) -> void:
	editor_process = value
	if not Engine.editor_hint:
		return
	set_process(value)
	

