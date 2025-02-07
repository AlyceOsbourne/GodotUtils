class_name Achievement
extends Resource

var id: String
var name: String
var description: String
var is_unlocked: bool = false
var progress: float = 0.0
var goal: float = 1.0

func _init(_id: String, _name: String, _description: String, _goal: float = 1.0):
    id = _id
    name = _name
    description = _description
    goal = _goal

func update_progress(amount: float):
    if is_unlocked:
        return
    progress = min(progress + amount, goal)
    if progress >= goal:
        unlock()

func unlock():
    is_unlocked = true
