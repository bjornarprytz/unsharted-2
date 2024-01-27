extends Node2D


@onready var poop : SoftBody2D = $SoftPoop
@onready var detection_area : Area2D = $DetectionArea

@onready var target_scale : Vector2 = poop.scale

const force : float = 200.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _input(event: InputEvent) -> void:
	
	if (event is InputEventKey and event.keycode == KEY_SPACE):
		poop.apply_force(Vector2.UP * force)

func _physics_process(delta: float) -> void:
	detection_area.global_position = poop.get_bones_center_position()
	poop.scale = poop.scale.move_toward(target_scale, delta)

func _on_detection_area_body_entered(body: Node2D) -> void:
	var thing = body.owner
	if thing is MiniPoop:
		var tween = create_tween()
		tween.tween_property(thing, "scale", Vector2.ZERO, 2.0)
		target_scale += (Vector2.ONE*.1)
		tween.tween_callback(thing.queue_free)
		
