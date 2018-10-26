extends Node2D

#batastroli (918,507) min (-48,507)

var level = 1
var timerTemp = 0
var timerSec = 0
var speedTroli = 0
var delayTroliTemp = 0
var toogleDelayTroli = 0
var toogleSpeed = [1,1,1,1,1,1,1,1,1,1]
var xTroliAwal = [-1008,-902,-796,-690,-584,-478,-372,-266,-160,-54]
var xTroli = [-1008,-902,-796,-690,-584,-478,-372,-266,-160,-54]
var letakTroli = [54,150,246,342,438,534,630,726,822,918]
#var xTroli = [-918,-822,-726,-630,-534,-438,-342,-246,-150,-54]
#var troli = [load("res://troliLemuru.tscn"),load("res://troliSlengseng.tscn"),load("res://troliLemuru.tscn"),load("res://troliLemuru.tscn"),load("res://troliSlengseng.tscn"),load("res://troliTongkol.tscn"),load("res://troliLemuru.tscn"),load("res://troliTongkol.tscn"),load("res://troliLemuru.tscn"),load("res://troliSlengseng.tscn")]
#var t = [troli[0].instance(),troli[1].instance(),troli[2].instance(),troli[3].instance(),troli[4].instance(),troli[5].instance(),troli[6].instance(),troli[7].instance(),troli[8].instance(),troli[9].instance()]
onready var t = [$troli1,$troli2,$troli3,$troli4,$troli5,$troli6,$troli7,$troli8,$troli9,$troli10]
#onready var t = [troli[0].instance(),troli[1].instance(),troli[2].instance(),troli[3].instance(),troli[4].instance(),troli[5].instance(),troli[6].instance(),troli[7].instance(),troli[8].instance(),troli[9].instance()]

func _ready():
	level = 1
	#set posisi awal loyang
	for i in range(0,10):
		add_child(t[i])
		t[i].set_position(Vector2(xTroliAwal[i],507))
	pass

func _process(delta):
	if timerTemp < 100:
		timerTemp = timerTemp + 1
		#speedTroli = xTroli + timerSec
	if timerTemp >= 100:
		timerSec = timerSec + 1
		timerTemp = 0
		#print(timerSec)
	gerakTroli10()
	gerakTroli9()
	gerakTroli8()
	gerakTroli7()
	gerakTroli6()
	gerakTroli5()
	gerakTroli4()
	gerakTroli3()
	gerakTroli2()
	gerakTroli1()
	pass


func gerakTroli10():
	if xTroli[10-1] < letakTroli[10-1]:
		xTroli[10-1] = xTroli[10-1] + toogleSpeed[10-1]*level
		t[10-1].set_position(Vector2(xTroli[10-1],507))
	pass
func gerakTroli9():
	if xTroli[9-1] < letakTroli[10-1]:
		xTroli[9-1] = xTroli[9-1] + toogleSpeed[9-1]*level
		t[9-1].set_position(Vector2(xTroli[9-1],507))
	pass
func gerakTroli8():
	if xTroli[8-1] < letakTroli[10-1]:
		xTroli[8-1] = xTroli[8-1] + toogleSpeed[8-1]*level
		t[8-1].set_position(Vector2(xTroli[8-1],507))
	pass
func gerakTroli7():
	if xTroli[7-1] < letakTroli[10-1]:
		xTroli[7-1] = xTroli[7-1] + toogleSpeed[7-1]*level
		t[7-1].set_position(Vector2(xTroli[7-1],507))
	pass
func gerakTroli6():
	if xTroli[6-1] < letakTroli[10-1]:
		xTroli[6-1] = xTroli[6-1] + toogleSpeed[6-1]*level
		t[6-1].set_position(Vector2(xTroli[6-1],507))
	pass
func gerakTroli5():
	if xTroli[5-1] < letakTroli[10-1]:
		xTroli[5-1] = xTroli[5-1] + toogleSpeed[5-1]*level
		t[5-1].set_position(Vector2(xTroli[5-1],507))
	pass
func gerakTroli4():
	if xTroli[4-1] < letakTroli[10-1]:
		xTroli[4-1] = xTroli[4-1] + toogleSpeed[4-1]*level
		t[4-1].set_position(Vector2(xTroli[4-1],507))
	pass
func gerakTroli3():
	if xTroli[3-1] < letakTroli[10-1]:
		xTroli[3-1] = xTroli[3-1] + toogleSpeed[3-1]*level
		t[3-1].set_position(Vector2(xTroli[3-1],507))
	pass
func gerakTroli2():
	if xTroli[2-1] < letakTroli[10-1]:
		xTroli[2-1] = xTroli[2-1] + toogleSpeed[2-1]*level
		t[2-1].set_position(Vector2(xTroli[2-1],507))
	pass
func gerakTroli1():
	if xTroli[1-1] < letakTroli[10-1]:
		xTroli[1-1] = xTroli[1-1] + toogleSpeed[1-1]*level
		t[1-1].set_position(Vector2(xTroli[1-1],507))
	pass

func _on_Area2D_area_entered(Area2D):
	for g in range(0,10,1):
		toogleSpeed[g] = 0
	pass
	
"""func gerakTroli():
	for j in range(9,-1,-1):
		if xTroli[j] < letakTroli[j]:
			xTroli[j] = xTroli[j] + toogleSpeed*level
			t[j].set_position(Vector2(xTroli[j],507))
		pass
	pass"""


func _on_Area2D_mouse_entered():
	xTroli[10-1] = xTroliAwal[3-1]
	for g in range(0,10,1):
		toogleSpeed[g] = 1
	pass
