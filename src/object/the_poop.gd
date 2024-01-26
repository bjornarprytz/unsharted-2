extends Node2D


@onready var poop : SoftBody2D = $SoftBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	poop.apply_force(Vector2.DOWN * (Time.get_ticks_msec() / 10.0))
