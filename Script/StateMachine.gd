extends Node
class_name StateMachine

onready var IDLE: = get_node("idle")
onready var WANDER: = get_node("wander")
onready var state: = IDLE

const DEBUG = true

enum STATES {IDLE, WANDER}

var direction = Vector2.ZERO
var history = []

func _ready():
	# Set the initial state to the first child node
	call_deferred("_enter_state")
	
func change_to(new_state):
	history.append(state)
	state = new_state
	_enter_state()

func back():
	if history.size() > 0:
		state = history.pop_back()
		_enter_state()

func _enter_state():
	# Give the new state a reference to this state machine script
	STATES.Controller = self
	state.enter()

# Route Game Loop function calls to
# current state handler method if it exists
func _process(delta):
	if state.has_method("process"):
		state.process(delta)

func _physics_process(delta):
	if state.has_method("physics_process"):
		state.physics_process(delta)
