class_name GlobalSingleton
extends Node2D

enum Outcome{
	Assphxiation,
	Ejection,
	Victory
}

signal GameOver(outcome: GlobalSingleton.Outcome)
signal Fart(magnitude: float)
signal PoopConsumed
signal ScoreUpdated(score: int)

@onready var audio :AudioStreamPlayer = $AudioStreamPlayer

var gas_volume : float = 0.0

var score : int:
	set(value):
		if (score == value):
			return
		score = value
		ScoreUpdated.emit(score)

func _ready() -> void:
	Global.PoopConsumed.connect(increment_score.bind(1))
	audio.finished.connect(audio.play)

func increment_score(value: int):
	score += value
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
