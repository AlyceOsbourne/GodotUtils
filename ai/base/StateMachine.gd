class_name StateMachine
extends Resource

var current_state: State
var ai: AIController

func _init(_ai: AIController, _default_state: GDScript = Thinking):
    ai = _ai
    if _default_state:
        _change_state(_default_state)

func _change_state(state_class: GDScript):
    if current_state and current_state.get_script() == state_class:
        return
    if current_state:
        current_state.exit()
    current_state = state_class.new(ai)
    current_state.enter()

func process(delta: float):
    if current_state:
        current_state.process(delta)

func physics_process(delta):
    if current_state:
        current_state.physics_process(delta)
