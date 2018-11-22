extends Node2D

var level = 1
#Timer
var rtemp = 0
var rtempplus = 1
var rsec = 0
var rmin = 5
var tsec = 0
var tmin = 0

var xTroliAwal = [-1008,-902,-796,-690,-584,-478,-372,-266,-160,-54]
var xTroli = [-1008,-902,-796,-690,-584,-478,-372,-266,-160,-54] #batastroli (918,507) min (-48,507)
var letakTroli = [54,150,246,342,438,534,630,726,822,918]
var letakTroliAwal = [54,150,246,342,438,534,630,726,822,918]
var letakTroliCek = [0,1,2,3,4,5,6,7,8,9]
var letakTroliCekTemp = [0,1,2,3,4,5,6,7,8,9]
var letakTemp = 0 #lem0,sle1,lem2,lem3,sle4,ton5,lem6,ton7,lem8,sle9
var cekJenisTroli = 0
onready var t = [$troli1,$troli2,$troli3,$troli4,$troli5,$troli6,$troli7,$troli8,$troli9,$troli10]
#var xTroli = [-918,-822,-726,-630,-534,-438,-342,-246,-150,-54]
#var troli = [load("res://troliLemuru.tscn"),load("res://troliSlengseng.tscn"),load("res://troliLemuru.tscn"),load("res://troliLemuru.tscn"),load("res://troliSlengseng.tscn"),load("res://troliTongkol.tscn"),load("res://troliLemuru.tscn"),load("res://troliTongkol.tscn"),load("res://troliLemuru.tscn"),load("res://troliSlengseng.tscn")]
#var t = [troli[0].instance(),troli[1].instance(),troli[2].instance(),troli[3].instance(),troli[4].instance(),troli[5].instance(),troli[6].instance(),troli[7].instance(),troli[8].instance(),troli[9].instance()]
onready var cArea = [$troli1/Area2D1,$troli2/Area2D2,$troli3/Area2D3,$troli4/Area2D4,$troli5/Area2D5,$troli6/Area2D6,$troli7/Area2D7,$troli8/Area2D8,$troli9/Area2D9,$troli10/Area2D10]
var mouseOnTroli = [false,false,false,false,false,false,false,false,false,false]
var mouseOnFreezer = [false,false,false,false,false,false,false,false,false,false]
var mouseOnKlik = [false,false,false,false,false,false,false,false,false,false]
var mouseOnTroliCek = [false,false,false,false,false,false,false,false,false,false]#pengecekan kedua letak mouse
onready var f = [$SSlot1,$SSlot2,$SSlot3,$SSlot4,$SSlot5,$SSlot6,$SSlot7,$SSlot8,$SSlot9,$SSlot10]
var freezeSlot = [0,0,0,0,0,0,0,0,0,0] # 0=kosong,1=lemuru,2=slengseng,3=tongkol
var ft = [preload("res:///assets/fLemuru.png"), preload("res:///assets/fSlengseng.png"),preload("res:///assets/fTongkol.png")]

func _ready():
	#menyembunyikan pause
	$NPause.hide()
	
	#reset level
	level = 1
	
	#set posisi awal loyang
	for i in range(0,10,1):
		add_child(t[i])
		t[i].set_position(Vector2(xTroliAwal[i],507))
	
	#hide loyang di freezer
	for j in range(0,10,1):
		f[j].hide()
		
	#Play Backsound
	if Global.musik == 1:
		$Backsound.play()
	else:
		$Backsound.stop()
	pass

func _process(delta):
	gameTimer()
	gerakTroli()
	dragAndDrop()
	freezer()
	pass

func gameTimer():
	rtemp += rtempplus
	if rtemp == 50:
		rtemp = 0
		rsec -= 1
	if rsec < 0:
		rsec = 59
		rmin -= 1
	if rmin == 0 && rsec == 0:
		rtempplus = 0
	$StatusBar/LTimer.text = str(rmin) +":"+ str(rsec).pad_zeros(2)
	pass

func gerakTroli():
	for i in range(10,0,-1):
		if xTroli[i-1] < letakTroli[i-1]:
			xTroli[i-1] = xTroli[i-1] + level
			t[i-1].set_position(Vector2(xTroli[i-1],507))

func dragAndDrop():
	for i in range(0,10,1):
		if Input.is_action_pressed("lClick"):
			if mouseOnTroli[i] == true:
				mouseOnTroliCek[i] = true
				for k in range(0,10,1):
					cArea[k].hide()
		if Input.is_action_just_released("lClick"):
			if xTroli[i-1] >= letakTroli[i-1]:
				t[i].set_position(Vector2(xTroli[i],507))
			mouseOnTroliCek[i] = false
			for k in range(0,10,1):
				cArea[k].show()
		if mouseOnTroliCek[i] == true:
			#letakTemp = letakTroli[i]
			t[i].set_position(get_viewport().get_mouse_position())
			#letakTroli[i] = letakTemp
	for j in range(0,10,1):
		if mouseOnFreezer[j] == true:
			if Input.is_action_just_released("lClick"):
				freezeSlot[j] = cekJenisTroli
				xTroli[j] = xTroliAwal[j]
				for g in range(0,10,1):
					if letakTroliCek[g] < letakTroliCek[j]:
						letakTroliCekTemp[g] = letakTroliCek[g] + 1
				letakTroliCekTemp[j] = 0
				for h in range(0,10,1):
					letakTroliCek[h] = letakTroliCekTemp[h]
					letakTroli[h] = letakTroliAwal[letakTroliCek[h]]
			if Input.is_action_pressed("rClick"):
				freezeSlot[j] = 0

"""func dragAndDrop():
	for i in range(0,10,1):
		if mouseOnKlik[i] == true:
			if mouseOnTroli[i] == true:
				if Input.is_action_pressed("lClick"):
					mouseOnTroliCek[i] = true
					mouseOnKlik[i] = false
				elif Input.is_action_just_released("lClick"):
					mouseOnTroliCek[i] = false
			if mouseOnTroliCek[i] == true:
				letakTemp = letakTroli[i]
				t[i].set_position(get_viewport().get_mouse_position())
				letakTroli[i] = letakTemp
	for j in range(0,10,1):
		if mouseOnFreezer[j] == true:
			if Input.is_action_just_released("lClick"):
				freezeSlot[j] = 3
				xTroli[j] = xTroliAwal[j]
				for g in range(0,10,1):
					if letakTroliCek[g] < letakTroliCek[j]:
						letakTroliCekTemp[g] = letakTroliCek[g] + 1
				letakTroliCekTemp[j] = 0
				for h in range(0,10,1):
					letakTroliCek[h] = letakTroliCekTemp[h]
					letakTroli[h] = letakTroliAwal[letakTroliCek[h]]"""

func freezer():
	for s in range(0,10,1):
		if freezeSlot[s] == 0:
			f[s].hide()
		if freezeSlot[s] == 1:
			f[s].set_texture(ft[1-1])
			f[s].show()
		if freezeSlot[s] == 2:
			f[s].set_texture(ft[2-1])
			f[s].show()
		if freezeSlot[s] == 3:
			f[s].set_texture(ft[3-1])
			f[s].show()
		if freezeSlot[s] > 3:
			print("freezeSlot > 3")
	pass

func _on_Area2D10_mouse_entered():
	mouseOnTroli[10-1] = true
	cekJenisTroli = 2
	pass
func _on_Area2D10_mouse_exited():
	mouseOnTroli[10-1] = false
	pass
func _on_Area2D9_mouse_entered():
	mouseOnTroli[9-1] = true
	cekJenisTroli = 1
	pass
func _on_Area2D9_mouse_exited():
	mouseOnTroli[9-1] = false
	pass
func _on_Area2D8_mouse_entered():
	mouseOnTroli[8-1] = true
	cekJenisTroli = 3
	pass
func _on_Area2D8_mouse_exited():
	mouseOnTroli[8-1] = false
	pass
func _on_Area2D7_mouse_entered():
	mouseOnTroli[7-1] = true
	cekJenisTroli = 1
	pass
func _on_Area2D7_mouse_exited():
	mouseOnTroli[7-1] = false
	pass
func _on_Area2D6_mouse_entered():
	mouseOnTroli[6-1] = true
	cekJenisTroli = 3
	pass
func _on_Area2D6_mouse_exited():
	mouseOnTroli[6-1] = false
	pass
func _on_Area2D5_mouse_entered():
	mouseOnTroli[5-1] = true
	cekJenisTroli = 2
	pass
func _on_Area2D5_mouse_exited():
	mouseOnTroli[5-1] = false
	pass
func _on_Area2D4_mouse_entered():
	mouseOnTroli[4-1] = true
	cekJenisTroli = 1
	pass
func _on_Area2D4_mouse_exited():
	mouseOnTroli[4-1] = false
	pass
func _on_Area2D3_mouse_entered():
	mouseOnTroli[3-1] = true
	cekJenisTroli = 1
	pass
func _on_Area2D3_mouse_exited():
	mouseOnTroli[3-1] = false
	pass
func _on_Area2D2_mouse_entered():
	mouseOnTroli[2-1] = true
	cekJenisTroli = 2
	pass
func _on_Area2D2_mouse_exited():
	mouseOnTroli[2-1] = false
	pass
func _on_Area2D1_mouse_entered():
	mouseOnTroli[1-1] = true
	cekJenisTroli = 1
	pass
func _on_Area2D1_mouse_exited():
	mouseOnTroli[1-1] = false
	pass

func _on_Area2DSlot10_mouse_entered():
	mouseOnFreezer[10-1] = true
	pass
func _on_Area2DSlot10_mouse_exited():
	mouseOnFreezer[10-1] = false
	pass
func _on_Area2DSlot9_mouse_entered():
	mouseOnFreezer[9-1] = true
	pass
func _on_Area2DSlot9_mouse_exited():
	mouseOnFreezer[9-1] = false
	pass
func _on_Area2DSlot8_mouse_entered():
	mouseOnFreezer[8-1] = true
	pass
func _on_Area2DSlot8_mouse_exited():
	mouseOnFreezer[8-1] = false
	pass
func _on_Area2DSlot7_mouse_entered():
	mouseOnFreezer[7-1] = true
	pass
func _on_Area2DSlot7_mouse_exited():
	mouseOnFreezer[7-1] = false
	pass
func _on_Area2DSlot6_mouse_entered():
	mouseOnFreezer[6-1] = true
	pass
func _on_Area2DSlot6_mouse_exited():
	mouseOnFreezer[6-1] = false
	pass
func _on_Area2DSlot5_mouse_entered():
	mouseOnFreezer[5-1] = true
	pass
func _on_Area2DSlot5_mouse_exited():
	mouseOnFreezer[5-1] = false
	pass
func _on_Area2DSlot4_mouse_entered():
	mouseOnFreezer[4-1] = true
	pass
func _on_Area2DSlot4_mouse_exited():
	mouseOnFreezer[4-1] = false
	pass
func _on_Area2DSlot3_mouse_entered():
	mouseOnFreezer[3-1] = true
	pass
func _on_Area2DSlot3_mouse_exited():
	mouseOnFreezer[3-1] = false
	pass
func _on_Area2DSlot2_mouse_entered():
	mouseOnFreezer[2-1] = true
	pass
func _on_Area2DSlot2_mouse_exited():
	mouseOnFreezer[2-1] = false
	pass
func _on_Area2DSlot1_mouse_entered():
	mouseOnFreezer[1-1] = true
	pass
func _on_Area2DSlot1_mouse_exited():
	mouseOnFreezer[1-1] = false
	pass

func _on_BMenu_pressed():
	if Global.musik == 1:
		$NPause/BackgroundPause/LMusik.set_text(str("Musik: On"))
	else:
		$NPause/BackgroundPause/LMusik.set_text(str("Musik: Off"))
	$NPause.show()
func _on_BKembali_pressed():
	$NPause.hide()
func _on_BRestart_pressed():
	get_tree().change_scene("res://Penyimpanan.tscn")
func _on_BMusik_pressed():
	if Global.musik == 1:
		$NPause/BackgroundPause/LMusik.set_text(str("Musik: Off"))
		Global.musik = 0
		$Backsound.stop()
	else:
		$NPause/BackgroundPause/LMusik.set_text(str("Musik: On"))
		Global.musik = 1
		$Backsound.play()
func _on_BMainMenu_pressed():
	get_tree().change_scene("res://Menu.tscn")