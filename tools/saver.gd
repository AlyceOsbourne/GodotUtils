class_name Saver

static func save(path: String) -> void:
    var dir_path = path.get_base_dir()
    var dir = DirAccess.open(dir_path)
    if not dir:
        DirAccess.make_dir_recursive_absolute(dir_path)

    var data = {}
    var file = FileAccess.open(path, FileAccess.WRITE_READ)
    Engine.get_main_loop().root.propagate_call("_save", {}, true)
    file.store_string(JSON.stringify(data))
    file.close()

static func load(path: String) -> void:
    if not FileAccess.file_exists(path):
        printerr("Save file not found.")
        return

    Engine.get_main_loop().root.propagate_call("_load", JSON.parse_string(FileAccess.get_file_as_string(path)), true)
