class_name Pauser

static func pause_with_scene(pause_scene: PackedScene):
    var ml = Engine.get_main_loop()
    var pause_menu: Node = pause_scene.instantiate()
    ml.current_scene.set_process(false)
    ml.current_scene.set_physics_process(false)
    ml.root.add_child(pause_menu)
    await pause_menu.tree_exited
    ml.current_scene.set_process(true)
    ml.current_scene.set_physics_process(true)
