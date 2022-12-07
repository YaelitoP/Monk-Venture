extends CanvasLayer

onready var bars: = $Control/bars
onready var healthbar: = $Control/bars/healthBar


func _ready() -> void:
	if owner.has_signal("health_status"):
		owner.connect("health_status", self, "update_health")


func update_health(health):
	healthbar.value = health
