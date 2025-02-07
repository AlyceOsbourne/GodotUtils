class_name Utility
extends Resource

@export var curve: Curve

func evaluate(ai: AIController) -> float:
    if curve:
        return curve.sample_baked(call("_evaluate", ai))
    return call("_evaluate", ai)
