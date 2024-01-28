class_name MiniPoop
extends Node2D

@onready var poop : RigidBody2D = $MiniPoop
@onready var detection_area : Area2D = $MiniPoop/DetectionArea


func flush():
	poop.apply_impulse(Vector2.DOWN * 400.0)

func _exit_tree() -> void:
	Global.munch_effect()
