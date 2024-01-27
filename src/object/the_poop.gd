extends Node2D


@onready var poop : CharacterBody2D = $CharacterPoop
@onready var detection_area : Area2D = $DetectionArea

@onready var target_scale : Vector2 = scale

const force : float = 300.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _input(event: InputEvent) -> void:
	if (event is InputEventKey and event.keycode == KEY_SPACE):
		poop.velocity += Vector2.UP * force
	
	if (event is InputEventKey and event.keycode == KEY_A):
		poop.velocity += Vector2.LEFT * force
	if (event is InputEventKey and event.keycode == KEY_D):
		poop.velocity += Vector2.RIGHT * force

func _physics_process(delta: float) -> void:
	scale = scale.move_toward(target_scale, delta)
	
	

func internal_inflate(pressure: float):
	pass

func _on_detection_area_body_entered(body: Node2D) -> void:
	var thing = body.owner
	if thing is MiniPoop:
		thing.poop.collision_layer = 0
		var tween = create_tween()
		tween.tween_property(thing, "modulate:a", 0.0, .5)
		target_scale += (Vector2.ONE * .1)
		tween.tween_callback(thing.queue_free)
		
