extends Node2D

var a = 0
var b = 0
onready var z = $Sprite1

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	if a == 1: 
		if Input.is_action_pressed("lClick"):
			b = 1
		elif Input.is_action_just_released("lClick"):
			b = 0
	if b == 1:
		z.set_position(get_viewport().get_mouse_position())
	pass

func _on_Area2D_mouse_entered():
	a = 1

func _on_Area2D_mouse_exited():
	a = 0
