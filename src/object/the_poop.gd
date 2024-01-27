extends RigidBody2D

@onready var detection_area : Area2D = $DetectionArea

@onready var animation : AnimatedSprite2D = $Animation
@onready var detection_shape : Node2D = $DetectionArea/Shape
@onready var poop_shape : Node2D = $Shape

const force : float = 1000.0

var size: int = 0
var target_scale : Vector2 = Vector2.ONE

func _physics_process(delta):
	
	animation.scale = animation.scale.move_toward(target_scale, delta)
	detection_shape.scale = detection_shape.scale.move_toward(target_scale, delta)
	poop_shape.scale = poop_shape.scale.move_toward(target_scale, delta)
	
	if !animation.is_playing():
		animation.play("Idle")
	
	if Input.is_action_pressed("left"):
		apply_force(Vector2.LEFT * force * delta)
	if Input.is_action_pressed("right"):
		apply_force(Vector2.RIGHT * force * delta)

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
		target_scale += (Vector2.ONE * .02)
		tween.tween_property(thing, "modulate:a", 0.0, .5)
		tween.tween_callback(thing.queue_free)
		Global.PoopConsumed.emit()
		
		if (target_scale.x > 1.2):
			

func fart():
	# Clear out the gas
	# Fart sound depending on gas volume
	# Eject Poop (disable anus)
	# If player is ejected, game over
	# Otherwise, close anus and resume
