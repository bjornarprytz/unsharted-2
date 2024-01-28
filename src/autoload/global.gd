class_name GlobalSingleton
extends Node2D

enum Outcome{
	Assphxiation,
	Ejection,
	Constapation
}

signal GameOver(outcome: GlobalSingleton.Outcome)
signal Fart(magnitude: float)
signal PoopConsumed
signal ScoreUpdated(score: int)

var gas_volume : float = 0.0

@onready var effects : AudioStreamPlayer = $Effects

@onready var much_sounds = [
	preload("res://assets/audio/effects/munch_1.wav"),
	preload("res://assets/audio/effects/munch_2.wav"),
	preload("res://assets/audio/effects/munch_3.wav")
]

func munch_effect():
	effects.pitch_scale = randf_range(0.9, 1.1)
	effects.stream = much_sounds.pick_random()
	effects.play()

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
