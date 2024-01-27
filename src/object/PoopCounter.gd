extends Label

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.ScoreUpdated.connect(_on_ScoreUpdated.bind())

func _on_ScoreUpdated(new_score : int):
	var score = new_score
	self.text = "Score: " + var_to_str(score)
