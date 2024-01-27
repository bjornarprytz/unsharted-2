extends Node2D

@onready var poop_spawner : PackedScene = preload("res://object/mini_poop.tscn")

@onready var spawn_area : ColorRect = $MiniPoopSpawn

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_area.get_rect()

const spawn_interval : float = .69

var spawn_timer := 0.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	spawn_timer += delta
	
	if (spawn_timer > spawn_interval):
		var mini_poop = poop_spawner.instantiate() as MiniPoop
		add_child(mini_poop)
		mini_poop.position = _get_random_spawn_point()
		spawn_timer = 0.0

func _get_random_spawn_point() -> Vector2:
	var low_x = spawn_area.get_rect().position.x
	var top_x = spawn_area.get_rect().position.x + spawn_area.get_rect().size.x
	var low_y = spawn_area.get_rect().position.y
	var top_y = spawn_area.get_rect().position.y + spawn_area.get_rect().size.y
	return Vector2(randf_range(low_x, top_x), randf_range(low_y, top_y))
