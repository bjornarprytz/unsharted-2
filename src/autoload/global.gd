class_name GlobalSingleton
extends Node2D


signal GameOver
signal Fart(magnitude: float)
signal PoopConsumed
signal ScoreUpdated(score: int)

var gas_volume : float = 0.0

var score : int:
	set(value):
		if (score == value):
			return
		score = value
		ScoreUpdated.emit(score)

func _ready() -> void:
	Global.PoopConsumed.connect(increment_score.bind(1))

func increment_score(value: int):
	score += value
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
