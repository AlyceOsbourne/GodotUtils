class_name Transition
extends ColorRect

@export var _to: PackedScene
@export var _fade_out_time: float = 2
@export var _fade_out_delay: float = 0
@export var _fade_in_time: float = 2
@export var _fade_in_delay: float = 1
@export var auto_transition: bool = true


func _init(
    to: PackedScene = null,
    fade_out_time: float = 2,
    fade_out_delay: float = 0,
    fade_in_time: float = 2,
    fade_in_delay: float = 1,
    material: Material = null

) -> void:

    self._to = to
    self._fade_out_time = fade_out_time
    self._fade_out_delay = fade_out_delay
    self._fade_in_time = fade_in_time
    self._fade_in_delay = fade_in_delay
    self.material = material

    var loop = Engine.get_main_loop()
    loop.root.add_child.call_deferred(self)

func _ready() -> void:
    assert(is_instance_valid(_to), "No scene to transfer to")

    top_level = true
    set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    custom_minimum_size = get_viewport_rect().size
    color = Color.TRANSPARENT

    if auto_transition:
        transition()

func transition():
    await transition_out()
    await data_transfer(_to)
    await transition_in()
    queue_free.call_deferred()

func transition_out():
    print("Transitioning Out")
    var t = create_tween()
    t.tween_property(self, "color", Color.BLACK, _fade_out_time).set_delay(_fade_out_delay).set_ease(Tween.EASE_IN)
    await t.finished

func transition_in():
    print("Transitioning In")
    var t = create_tween()
    t.tween_property(self, "color", Color.TRANSPARENT, _fade_in_time).set_delay(_fade_in_delay).set_ease(Tween.EASE_OUT)
    await t.finished

static func data_transfer(scene: PackedScene):
    var data = {}
    var loop := Engine.get_main_loop()

    loop.current_scene.propagate_call("_transfer_on_scene_change", [data], true)

    if loop.change_scene_to_packed(scene) != OK:
        return

    while loop.current_scene == null:
        await loop.process_frame

    loop.current_scene.propagate_call("_recieve_on_scene_change", [data], true)

    if not loop.current_scene.is_node_ready():
        await loop.current_scene.ready
