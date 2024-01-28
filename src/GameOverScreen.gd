extends Node2D

@onready var score_label: Label = $CanvasLayer/Score

@onready var ass_sounds : AudioStreamPlayer2D = $AssAudio

@onready var fart_sounds = [
preload("res://assets/audio/61047__timtube__fart.wav"),
preload("res://assets/audio/74637__ifartinurgeneraldirection__abrupt-fart-2.mp3"),
preload("res://assets/audio/94989__deleted_user_1391979__bad-chili-fart.wav"),
preload("res://assets/audio/402569__teddyferguson__fart.mp3"),
preload("res://assets/audio/523467__tv_ling__perfect-fart.mp3"),
preload("res://assets/audio/650652__frenkfurth__wav-fart-vegan-005.wav")
]

# Called when the node enters the scene tree for the first time.
func _ready():
	ass_sounds.stream = fart_sounds.pick_random()
	ass_sounds.play()
	
func _input(event):
	if (event is InputEventKey and event.keycode == KEY_SPACE and event.is_pressed()):
		get_tree().change_scene_to_file("res://main.tscn")

