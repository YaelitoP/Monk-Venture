extends Node2D

onready var monk: = $Monk

onready var monk_atk: int = monk.get_dmg()

func _ready() -> void:
	pass 


func _physics_process(delta: float) -> void:
	pass


func _on_area_atacks_body_entered(body: Node) -> void:
	if body.is_in_group("mobs"):
		monk.emit_signal("monk_dmg", monk_atk)
