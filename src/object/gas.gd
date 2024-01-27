class_name Gas
extends Area2D

@onready var shape : CollisionShape2D = $Shape
@onready var visual : ColorRect = $Visual

func _ready() -> void:
	Global.PoopConsumed.connect(_change_height.bind(1.0))

func _change_height(amount: float):
	shape.position.y -= (amount / 2.0)
	shape.shape.size.y += amount
	visual.position.y -= amount
	visual.size.y += amount

