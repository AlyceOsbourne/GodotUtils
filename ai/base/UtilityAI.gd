@tool
class_name UtilityAI
extends Resource

@export var _decisions: Dictionary[GDScript, Utility] = {
    Thinking: ExpressionUtility.new("0.001")
}

func _init(decisions: Dictionary[GDScript, Utility] = {}) -> void:
    _decisions.merge(_decisions, true)

func evaluate(ai: AIController) -> GDScript:
    if _decisions.is_empty():
        return Thinking
    var evaluations = {}
    for k in _decisions:
        evaluations[k] = _decisions[k].evaluate(ai)
    var keys = evaluations.keys()
    keys.sort_custom(func(x: GDScript, y: GDScript): return evaluations[x] > evaluations[y])
    return keys[0]
