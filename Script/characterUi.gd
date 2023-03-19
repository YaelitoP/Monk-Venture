extends CanvasLayer

onready var bars: = $Control/bars
onready var healthbar: = $Control/bars/healthBar
onready var arrow: = $Control/bars/arrow
onready var arrow2: = $Control/bars/arrow2
onready var tick: = 0.0


func _ready() -> void:
	if owner.has_signal("health_status"):
# warning-ignore:return_value_discarded
		owner.connect("health_status", self, "update_health")
	if owner.has_signal("dash_status"):
# warning-ignore:return_value_discarded
		owner.connect("dash_status", self, "update_stamina")

func update_health(health):
	healthbar.value = health

func update_stamina(cooldown, count):
	if cooldown == 0:
		tick = 0.0
		if count == 1:
			arrow.set_self_modulate(Color(1, 1, 1, 1))
		if count == 2:
			arrow2.set_self_modulate(Color(1, 1, 1, 1))
		
	for x in cooldown:
		tick += 0.02
		if count == 1:
			
			arrow2.set_self_modulate(Color(1, 1, 1, tick))
			
		if count == 0:
			
			arrow2.set_self_modulate(Color(1, 1, 1, 0))
			
			arrow.set_self_modulate(Color(1, 1, 1, tick))
			
