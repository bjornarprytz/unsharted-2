class_name Gas
extends Area2D

@onready var shape : CollisionShape2D = $Shape
@onready var visual : ColorRect = $Visual

@export var bounce_force = 3000


func _ready() -> void:
	Global.PoopConsumed.connect(_change_height.bind(10.0))

func _change_height(amount: float):
	shape.position.y -= (amount / 2.0)
	shape.shape.size.y += amount
	visual.position.y -= amount
	visual.size.y += amount



func _on_body_entered(body: RigidBody2D):
	if body.name == "ThePoop":
		body.add_constant_force(Vector2.UP * bounce_force)


func _on_body_exited(body):
	if body.name == "ThePoop":
		body.constant_force = Vector2.ZERO
