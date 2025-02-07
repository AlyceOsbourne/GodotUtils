class_name DeveloperConsole
extends Control

enum LogLevel {
    INFO,
    WARNING,
    ERROR,
    SUCCESS
}

var input: LineEdit
var output: RichTextLabel
var commands: Dictionary[StringName, Callable] = {}
var help: Dictionary[StringName, String] = {}

func _ready() -> void:
    name = "Console"
    var container = VSplitContainer.new()
    var vbox = VBoxContainer.new()

    var panel = Panel.new()
    var pad = Control.new()

    input = LineEdit.new()
    output = RichTextLabel.new()

    vbox.custom_minimum_size.y = 200

    set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    output.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

    container.size_flags_vertical = Control.SIZE_EXPAND_FILL
    panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
    output.size_flags_vertical = Control.SIZE_EXPAND_FILL

    output.bbcode_enabled = true
    output.scroll_active = true
    output.scroll_following = true

    input.text_submitted.connect(_process_command)

    vbox.add_child(panel)
    vbox.add_child(input)
    panel.add_child(output)

    container.add_child(vbox)
    container.add_child(pad)

    add_child(container)

    _toggle()

func _process_command(text: String):
    log_message(text, LogLevel.INFO)
    var command = text.split(" ", false, 1)[0]
    var args = JSON.parse_string("[%s]" % text.trim_prefix(command))
    if command in commands:
        var result = commands[command].callv(args if args else [])
        if result and result != "":
            log_message(str(result), LogLevel.SUCCESS)
    else:
        log_message("Command does not exist: %s" % command, LogLevel.ERROR)
    input.clear()
    input.grab_focus()

func register_command(name: StringName, callable: Callable, help_text = "No help text provided.") -> void:
    commands[name] = callable
    help[name] = help_text

func log_message(text: String, level: LogLevel = LogLevel.INFO):
    var timestamp = "[" + Time.get_time_string_from_system() + "] "
    var color_tag = ""
    match level:
        LogLevel.INFO: color_tag = "[color=white]"
        LogLevel.WARNING: color_tag = "[color=yellow]"
        LogLevel.ERROR: color_tag = "[color=red]"
        LogLevel.SUCCESS: color_tag = "[color=green]"
    var formatted_text = timestamp + color_tag + text + "[/color]"
    print(formatted_text)
    output.append_text(formatted_text + "\n")

func _unhandled_key_input(event: InputEvent) -> void:
    if event is InputEventKey and event.is_pressed():
        match event.keycode:
            KEY_APOSTROPHE:
                _toggle()
            KEY_ESCAPE when visible:
                _toggle()
    if visible:
        get_viewport().set_input_as_handled()

func _toggle():
    visible = !visible
    mouse_filter = Control.MOUSE_FILTER_IGNORE if not visible else Control.MOUSE_FILTER_STOP
    if visible:
        input.grab_focus()
    else:
        input.release_focus()
