class_name PrefabDeveloperConsole
extends DeveloperConsole

func _ready() -> void:
    super._ready()
    register_command("help", _help, "Shows a help message, just like this one!")
    register_command("?", _help, "Shows a help message!")
    register_command("info", _debug_info, "Displays debug information, useful for debugging!")
    register_command("quit", func(): get_tree().quit(), "Quits the game")
    register_command("clear", func(): output.clear(), "Clears the console output")
    register_command("debug_tree", _debug_tree, "Displays the scene tree")
    register_command("reload_scene", func(): get_tree().reload_current_scene())

func _help(name="") -> String:
    if name == "":
        var output = "\n\tAvailable Commands:\n"
        for k in commands.keys().filter(func(x): return x in help):
            output += "\t\t%s: \n\t\t\t%s\n" % [k, help[k]]
        return output
    if name not in help:
        log_message("Command does not exist: %s" % name, LogLevel.ERROR)
        return ""
    return help[name]

func _debug_info() -> String:
    return """
    [b]System Information[/b]
    ==========================
    [b]Godot Version:[/b] %s
    [b]Renderer:[/b] %s
    [b]OS:[/b] %s
    [b]Architecture:[/b] %s
    [b]CPU Threads:[/b] %d
    [b]Video Adapter:[/b] %s
    [b]Resolution:[/b] %dx%d @ %dHz

    [b]Project Information[/b]
    ==========================
    [b]Project Name:[/b] %s
    [b]Main Scene:[/b] %s

    [b]Performance Metrics[/b]
    ==========================
    [b]Current FPS:[/b] %d
    [b]Delta Time:[/b] %.4f s
    [b]Physics Frames:[/b] %d

    [b]Memory Usage[/b]
    ==========================
    [b]RAM Usage:[/b] %.2f MB
    [b]VRAM Usage:[/b] %.2f MB

    [b]Input Devices[/b]
    ==========================
    [b]Mouse Connected:[/b] %s
    [b]Gamepads Connected:[/b] %d

    """ % [
        Engine.get_version_info().get("string"),
        RenderingServer.get_rendering_device().get_device_name(),
        OS.get_name(),
        Engine.get_architecture_name(),
        OS.get_processor_count(),
        RenderingServer.get_video_adapter_name(),
        DisplayServer.window_get_size().x, DisplayServer.window_get_size().y,
        DisplayServer.screen_get_refresh_rate(),

        ProjectSettings.get("application/config/name"),
        ProjectSettings.get("application/run/main_scene"),

        Performance.get_monitor(Performance.TIME_FPS),
        Performance.get_monitor(Performance.TIME_PROCESS),
        Engine.get_physics_frames(),

        OS.get_static_memory_usage() / 1024.0 / 1024.0,
        Performance.get_monitor(Performance.RENDER_VIDEO_MEM_USED) / 1024.0 / 1024.0,

        "Yes" if Input.mouse_mode != Input.MOUSE_MODE_HIDDEN else "No",
        Input.get_connected_joypads().size(),
    ]

func _debug_tree() -> String:
    return "\nCurrent Scene\n\t" + "\n\t".join(get_tree_string_pretty().split("\n"))
