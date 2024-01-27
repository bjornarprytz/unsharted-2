extends RigidBody2D

@onready var detection_area : Area2D = $DetectionArea
@onready var animation : AnimatedSprite2D = $Animation
const force : float = 1000.0

var size: int = 0

func _physics_process(delta):
	if !animation.is_playing():
		animation.play("Idle")
	
	if Input.is_action_pressed("left"):
		apply_force(Vector2.LEFT * force * delta)
	if Input.is_action_pressed("right"):
		apply_force(Vector2.RIGHT * force * delta)
	if Input.is_action_pressed("down"):
		apply_force(Vector2.DOWN * force * delta)

var smash_timer : SceneTreeTimer
var aborted_smash : bool

func _input(event: InputEvent) -> void:
	if (event is InputEventKey and event.keycode == KEY_S):
		if event.is_pressed():
			sleeping = true
			var tween = create_tween()
			tween.tween_property(self, "rotation", 0.0, 0.3)
			animation.play("Windup")
			await animation.animation_finished
			if aborted_smash:
				aborted_smash = false
				sleeping = false
				return
			apply_impulse(Vector2.DOWN * 20.0)
			animation.play("Fall")
			await animation.animation_finished
			pass
		else:
			animation.stop()
			aborted_smash = true
			sleeping = false

func _on_detection_area_area_entered(area: Area2D) -> void:
	var thing = area.owner
	if thing is MiniPoop:
		animation.play("Munch")
		
		var tween = create_tween()
		tween.tween_property(thing, "modulate:a", 0.0, .5)
		tween.tween_callback(thing.queue_free)
		Global.PoopConsumed.emit()
