class_name Leaderboard


var leaderboard: Array[LeaderboardEntry]

var sort_function: Callable

func _init(_sort_function: Callable = func(a, b): return a.score > b.score):
    sort_function = _sort_function

func add_entry(player_name: String, score: int, metadata: Dictionary[StringName, Variant] = {}):
    var new_entry = LeaderboardEntry.new(player_name, score, metadata)
    leaderboard.append(new_entry)
    _sort_leaderboard()

func _sort_leaderboard():
    leaderboard.sort_custom(sort_function)

func get_top_n(n: int) -> Array[LeaderboardEntry]:
    return leaderboard.slice(0, min(n, leaderboard.size()))

func get_player_rank(player_name: String) -> int:
    for i in range(leaderboard.size()):
        if leaderboard[i].player_name == player_name:
            return i + 1
    return -1

func clear_leaderboard():
    leaderboard.clear()

func save_leaderboard(path: String):
    var file = FileAccess.open(path, FileAccess.WRITE)
    if file:
        var data = []
        for entry in leaderboard:
            data.append({"name": entry.player_name, "score": entry.score, "metadata": entry.metadata})
        file.store_string(JSON.stringify(data))
        file.close()

func load_leaderboard(path: String):
    var file = FileAccess.open(path, FileAccess.READ)
    if file:
        var data = JSON.parse_string(file.get_as_text())
        if data is Array:
            leaderboard.clear()
            for entry in data:
                add_entry(entry["name"], entry["score"], entry.get("metadata", {}))
        file.close()
        _sort_leaderboard()
