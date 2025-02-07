class_name LeaderboardEntry
var player_name: String
var score: int
var metadata: Dictionary[StringName, Variant]

func _init(name: String, score_value: int, extra_data: Dictionary[StringName, Variant] = {}):
    player_name = name
    score = score_value
    metadata = extra_data
