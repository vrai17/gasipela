extends Node2D

onready var order1 = $PathLemuru1/FollowLemuru1
onready var sOrder1 = $PathLemuru1/FollowLemuru1/Sprite1
var o = [0,0,0,0,0]
func _ready():
	order1.set_offset(0)
	pass



func pOrder1():
	$PathLemuru1.show()
	if order1.get_offset() < 528.5:
		for i in range (0,528.5,0.1):
			order1.set_offset(order1.get_offset() + 100)

func _process(delta):
	if o[0] == 1:
		$PathLemuru1.show()
		sOrder1.set_rotation(deg2rad(90))
		if order1.get_offset() < 528.52:
			order1.set_offset(order1.get_offset() + 350 * delta)
			print(str(order1.get_offset()))
	if order1.get_offset() >= 528.52:
		print(str(order1.get_offset()))
		o[0] = 2
		sOrder1.set_rotation(deg2rad(-90))
	if o[0] == 2:
		if order1.get_offset() > 0:
			order1.set_offset(order1.get_offset() - 350 * delta)
	if order1.get_offset() <= 0:
		o[0] = 0
		$PathLemuru1.hide()
func _on_BOrder1_pressed():
	o[0] = 1
