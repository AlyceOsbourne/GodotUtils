class_name ExpressionUtility
extends Utility

@export_custom(PROPERTY_HINT_EXPRESSION, "") var expression: String

var _expression: Expression:
    get:
        if _expression == null:
            _expression = Expression.new()
            _expression.parse(expression)
        return _expression

func _evaluate(ai: AIController):
    return type_convert(_expression.execute([], ai), TYPE_FLOAT)

func _init(_expression: String = ""):
    expression = _expression
