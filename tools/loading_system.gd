class_name Loader
extends Resource

signal starting_loading(total_steps: int)
signal loaded_step(step: int)
signal finished_loading()

var processes: Array[Callable] = []

func _init(_processes: Array[Callable] = []):
    processes = _processes

func register_load_step(callable: Callable):
    processes.append(callable)
    return self

func start_loading() -> void:
    starting_loading.emit(processes.size())
    for process in processes.size():
        processes[process].call()
        loaded_step.emit(process)
    finished_loading.emit()

static func gather_loading_funcs():
    var callables: Array[Callable] = []
    Engine.get_main_loop().root.call_deferred("_on_game_init", [callables.append])
    return Loader.new(callables)
