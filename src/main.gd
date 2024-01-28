extends Node2D

@onready var poop_spawner : PackedScene = preload("res://object/mini_poop.tscn")

@onready var spawn_area : ColorRect = $MiniPoopSpawn

@onready var anus : StaticBody2D = $Anus/AnusCollider

@onready var gas : Gas = $Gas
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
func _ready() -> void:
	Global.Fart.connect(fart)

const spawn_interval : float = .69

var spawn_timer := 0.0

func _process(delta: float) -> void:
	spawn_timer += delta
	
	if (spawn_timer > spawn_interval):
		var mini_poop = poop_spawner.instantiate() as MiniPoop
		mini_poop.position = _get_random_spawn_point()
		add_child(mini_poop)
		spawn_timer = 0.0

func _get_random_spawn_point() -> Vector2:
	var low_x = spawn_area.get_rect().position.x
	var top_x = spawn_area.get_rect().position.x + spawn_area.get_rect().size.x
	var low_y = spawn_area.get_rect().position.y
	var top_y = spawn_area.get_rect().position.y + spawn_area.get_rect().size.y
	return Vector2(randf_range(low_x, top_x), randf_range(low_y, top_y))

func fart(magnitude: float):
	ass_sounds.stream = fart_sounds.pick_random()
	# TODO: Fart sound depending on gas volume
	ass_sounds.play()
	anus.process_mode = Node.PROCESS_MODE_DISABLED
	
	get_tree().call_group("MiniPoops", "flush")
	gas.deflate()
	
	await get_tree().create_timer(4.0).timeout
	
	anus.process_mode = Node.PROCESS_MODE_INHERIT


func _on_the_outside_area_entered(area: Area2D) -> void:
	if (area.owner is MainPoop):
		Global.GameOver.emit(GlobalSingleton.Outcome.Ejection)
