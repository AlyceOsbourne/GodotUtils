class_name UtilityAggregate
extends Utility

enum AggregationMode { SUM, PROD, MIN, MAX }
@export var utilities: Array[Utility]
@export var mode: AggregationMode

func _evaluate(ai: AIController):
    var evaluations = utilities.map(func(x: Utility): return x.evaluate(ai))

    match mode:
        AggregationMode.SUM: return evaluations.reduce(func(x, y): return x + y, 0)
        AggregationMode.PROD: return evaluations.reduce(func(x, y): return x * y, 1)
        AggregationMode.MIN: return evaluations.min()
        AggregationMode.MAX: return evaluations.max()
        _: return 0
