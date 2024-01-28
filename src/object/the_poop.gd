extends RigidBody2D

@onready var detection_area : Area2D = $DetectionArea

@onready var animation : AnimatedSprite2D = $Animation
@onready var detection_shape : Node2D = $DetectionArea/Shape
@onready var poop_shape : Node2D = $Shape

const force : float = 1000.0

var size: int = 0
var target_scale: Vector2 = Vector2.ONE

func _physics_process(delta):
	animation.scale = animation.scale.move_toward(target_scale, delta)
	detection_shape.scale = detection_shape.scale.move_toward(target_scale, delta)
	poop_shape.scale = poop_shape.scale.move_toward(target_scale, delta)
	
	if !animation.is_playing():
		animation.play("Idle" + _animation_postfix())
	
	if Input.is_action_pressed("left"):
		apply_force(Vector2.LEFT * force)
	if Input.is_action_pressed("right"):
		apply_force(Vector2.RIGHT * force)
	if Input.is_action_just_pressed("down"):
		_smash()
	if Input.is_action_just_released("down") and smashing:
		_abort_smash()
		
	print(position.y)
	if position.y > 800:
		Global.GameOver.emit(GlobalSingleton.Outcome.Ejection)
	
	var bodies = get_colliding_bodies()
	for b in bodies:
		if b.name == "PlayerBarrier":
			var areas = detection_area.get_overlapping_areas()
			for a in areas:
				if a.name == "Gas":
					Global.GameOver.emit(GlobalSingleton.Outcome.Assphxiation)

var smash_timer : SceneTreeTimer
var aborted_smash : bool
var smashing: bool

func _abort_smash():
	animation.play("Impact" + _animation_postfix())
	aborted_smash = true
	smashing = false
	sleeping = false
	lock_rotation = false
	await animation.animation_finished
	animation.play("Idle" + _animation_postfix())

func _smash() -> void:
	if smashing:
		return
	smashing = true             
	aborted_smash = false
	sleeping = true
	
	#var tween = create_tween()
	#tween.tween_property(self, "rotation", 0.0, 0.3)
	#await tween.finished
	rotation_degrees = 0
	lock_rotation = true
	if aborted_smash:
		aborted_smash = false
		smashing = false
		sleeping = false
		lock_rotation = false
		return
	
	_windup_animation()
	
	await get_tree().create_timer(2.0).timeout
	
	apply_impulse(Vector2.DOWN * 30.0)
	
	Global.Fart.emit(linear_velocity.length() + Global.gas_volume)
	smashing = false
	sleeping = false

func _windup_animation():
	animation.play("Windup"+_animation_postfix())
	await animation.animation_finished      
	animation.play("Fall"+_animation_postfix())


func _on_detection_area_area_entered(area: Area2D) -> void:
	var thing = area.owner
	if thing is MiniPoop:
		thing.poop.sleeping = true
		thing.poop.gravity_scale = 0.0
		thing.reparent.call_deferred(self)
		if !smashing:
			animation.play("Munch"+_animation_postfix())
		var tween = create_tween()
		target_scale += (Vector2.ONE * .02)
		tween.tween_property(thing, "modulate:a", 0.0, .5)
		tween.tween_callback(thing.queue_free)
		Global.PoopConsumed.emit()

func _animation_postfix() -> String:
	if (target_scale.x > 1.3):
		return "_Medium"
	else:
		return ""


