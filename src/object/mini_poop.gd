class_name MiniPoop
extends Node2D

@onready var poop : SoftBody2D = $MiniPoop
@onready var detection_area : Area2D = $DetectionArea


func _physics_process(delta: float) -> void:
	detection_area.global_position = poop.get_bones_center_position()