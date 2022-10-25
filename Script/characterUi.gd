extends CanvasLayer

onready var bars: = $Control/bars
onready var healthbar: = $Control/bars/healthBar


func _ready() -> void:
	yield(get_tree(), "idle_frame")
	healthbar.rect_scale = Vector2(2, 2)
	if get_parent().owner.has_signal("health_status"):
		get_parent().owner.connect("health_status", self, "update_health")

func update_health(health):
	healthbar.value = health
