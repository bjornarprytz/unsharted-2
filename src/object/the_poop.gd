extends RigidBody2D

@onready var detection_area : Area2D = $DetectionArea
@onready var target_scale : Vector2 = scale
@onready var chunk_spawnr : PackedScene = preload("res://object/chunk.tscn")
const force : float = 300.0

var size: int = 0

func _input(event: InputEvent) -> void:
	if (event is InputEventKey and event.keycode == KEY_SPACE and event.is_pressed()):
		apply_impulse(Vector2.DOWN * force)
	
	if (event is InputEventKey and event.keycode == KEY_A and event.is_pressed()):
		apply_impulse(Vector2.LEFT * force)
	if (event is InputEventKey and event.keycode == KEY_D and event.is_pressed()):
		apply_impulse(Vector2.RIGHT * force)

func _physics_process(delta: float) -> void:
	if !$AnimatedSprite2D.is_playing():
		$AnimatedSprite2D.play("Idle")

func _on_detection_area_area_entered(area: Area2D) -> void:
	var thing = area.owner
	if thing is MiniPoop:
		$AnimatedSprite2D.play("Munch")
		
		var tween = create_tween()
		tween.tween_property(thing, "modulate:a", 0.0, .5)
		target_scale += (Vector2.ONE * .1)
		tween.tween_callback(thing.queue_free)
		Global.PoopConsumed.emit()
		_increase_size()

func _increase_size():
	size += 1
	target_scale += Vector2.ONE * 0.05
	print(target_scale)
	scale += (Vector2.ONE * .1)
	
	if (size % 5 == 0):
		add_chunk()
func add_chunk():
	var chunk = chunk_spawnr.instantiate()
