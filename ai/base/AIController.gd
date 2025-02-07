@tool
class_name AIController
extends Node

@export var entity: Node = self
@export var utility_ai: UtilityAI = UtilityAI.new()

var state_machine: StateMachine = StateMachine.new(self)

func _process(delta: float) -> void:
    if not Engine.is_editor_hint():
        state_machine.process(delta)

func _physics_process(delta: float) -> void:
    if not Engine.is_editor_hint():
        state_machine.physics_process(delta)

func think(force_reevaluation: bool = false):
    if force_reevaluation:
        state_machine._change_state(Thinking)
        return
    var decision = utility_ai.evaluate(self)
    state_machine._change_state(decision)
