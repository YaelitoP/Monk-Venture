extends Area2D

onready var area: = $moveArea
onready var boundaries: = [] setget , get_boundaries
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	boundaries.append(Vector2(area.global_position.x - area.shape.extents.x, area.global_position.x + area.shape.extents.x))
	boundaries.append(Vector2(area.global_position.y - area.shape.extents.y, area.global_position.y + area.shape.extents.y))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
func get_boundaries():
	return boundaries
