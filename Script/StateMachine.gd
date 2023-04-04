extends Node
class_name StateMachine

onready var IDLE = get_node("idle")
onready var WANDER = get_node("wander")
onready var SEEK = get_node("seek")
onready var parent = get_parent()
onready var state = IDLE

const DEBUG = true

enum STATES {
	IDLE,
	WANDER,
	SEEK
}

var direction = Vector2.ZERO
var history = []

func _ready() -> void:
	# Set the initial state to the first child node
	for child in get_children():
		child.fsm = self
		child.dragon = parent
	call_deferred("_enter_state")

func change_to(new_state) -> void:
	history.append(state)
	state = new_state
	_enter_state()

func back() -> void:
	if history.size() > 0:
		state = history.pop_back()
		_enter_state()

func _enter_state() -> void:
	# Give the new state a reference to this state machine script
	state.enter()
	parent.timer.start()
	parent.wait.start()

# Route Game Loop function calls to
# current state handler method if it exists
func _process(delta: float) -> void:
	if state.has_method("process"):
		state.process(delta)

func _physics_process(delta: float) -> void:
	if state.has_method("_physics_update"):
		state._physics_update(delta)

func get_random_state():
	var state_count = [IDLE, WANDER]
	state_count.shuffle()
	var random_index = randi() % state_count.size()
	var state_list = STATES.values()
	var random_state = state_list[random_index]
	var next_state = state
	if random_state == 0:
		next_state = IDLE
	else:
		next_state = WANDER
	return next_state
