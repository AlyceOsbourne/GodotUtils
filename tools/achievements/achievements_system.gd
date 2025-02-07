class_name AchievementSystem
extends Resource

signal achievement_unlocked(id: String)

var achievements: Dictionary[StringName, Achievement] = {}

func add_achievement(id: String, name: String, description: String, goal: float = 1.0) -> AchievementSystem:
    if id in achievements:
        return
    achievements[id] = Achievement.new(id, name, description, goal)
    return self

func increment_progress(id: String, amount: float) -> AchievementSystem:
    if id in achievements:
        achievements[id].update_progress(amount)
        if achievements[id].is_unlocked:
            achievement_unlocked.emit(id)
    return self

func is_unlocked(id: String) -> bool:
    return achievements.get(id, false)

func _save():
    var save_data = {}
    for id in achievements:
        save_data[id] = {
            "is_unlocked": achievements[id].is_unlocked,
            "progress": achievements[id].progress
        }
    var file = FileAccess.open("user://achievements.save", FileAccess.WRITE)
    file.store_string(JSON.stringify(save_data))
    file.close()

func _load():
    if not FileAccess.file_exists("user://achievements.save"):
        return
    var file = FileAccess.open("user://achievements.save", FileAccess.READ)
    var data = JSON.parse_string(file.get_as_text())
    file.close()
    if data:
        for id in data.keys():
            if id in achievements:
                achievements[id].is_unlocked = data[id]["is_unlocked"]
                achievements[id].progress = data[id]["progress"]
