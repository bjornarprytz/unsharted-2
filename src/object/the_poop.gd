extends RigidBody2D

@onready var detection_area : Area2D = $DetectionArea
const force : float = 1000.0

var size: int = 0

func _process(delta):
	if !$AnimatedSprite2D.is_playing():
		$AnimatedSprite2D.play("Idle")
	
	if Input.is_action_pressed("left"):
		apply_force(Vector2.LEFT * force)
	if Input.is_action_pressed("right"):
		apply_force(Vector2.RIGHT * force)
	if Input.is_action_pressed("down"):
		
		apply_force(Vector2.DOWN * force)

var smash_tween : Tween

func _input(event: InputEvent) -> void:
	if (event is InputEventKey and event.keycode == KEY_S):
		
		if event.is_pressed():
			smash_tween = create_tween()

			#if Input.is_action_just_pressed("down"):
				#$AnimatedSprite2D.play("Windup")
			#$AnimatedSprite2D.play("Fall")
			apply_impulse(Vector2.DOWN * force)
		else:
			smash_tween.kill()
	

func _physics_process(delta: float) -> void:
	pass

func _on_detection_area_area_entered(area: Area2D) -> void:
	var thing = area.owner
	if thing is MiniPoop:
		$AnimatedSprite2D.play("Munch")
		
		var tween = create_tween()
		tween.tween_property(thing, "modulate:a", 0.0, .5)
		tween.tween_callback(thing.queue_free)
		Global.PoopConsumed.emit()
