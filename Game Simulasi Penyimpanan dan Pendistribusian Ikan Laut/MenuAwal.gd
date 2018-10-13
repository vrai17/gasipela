extends Node2D

func _ready():
	$BSoundOn.show()
	$BSoundOff.hide()

func _on_BSoundOn_pressed():
	$BSoundOff.show()
	$BSoundOn.hide()

func _on_BSoundOff_pressed():
	$BSoundOn.show()
	$BSoundOff.hide()
