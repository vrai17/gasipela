extends Node2D

#SQLite
const SQLite = preload("res://lib/gdsqlite.gdns")
var db
#Level
var level = 1
#Timer
var rtemp = 0
var rtempplus = 1
var rsec = 0
var rmin = 5
var tsec = 0
var tmin = 0
var gameEnd = false
var gameEndCek = 0
#Menghitung lama pendinginan
var waktuSimpan = [0,0,0,0,0,0,0,0,0,0]
var waktuMinusSimpan = [0,100,200]
#Skor
var cSkor = 0
var coin = 0
#Troli
var x = -54
var xTroli = [-1008,-902,-796,-690,-584,-478,-372,-266,-160,-54] #batastroli (918,507) min (-48,507)
var xTroliAwal = [-1008,-902,-796,-690,-584,-478,-372,-266,-160,-54]
var letakTroli = [54,150,246,342,438,534,630,726,822,918]
var letakTroliAwal = [54,150,246,342,438,534,630,726,822,918]
var letakTroliCek = [0,1,2,3,4,5,6,7,8,9]
var letakTroliCekTemp = [0,1,2,3,4,5,6,7,8,9]
var letakTemp = 0 #lem0,sle1,lem2,lem3,sle4,ton5,lem6,ton7,lem8,sle9
var cekJenisTroli = 0 #mengecek jenis ikan
var slot = -1
onready var t = [$troli1,$troli2,$troli3,$troli4,$troli5,$troli6,$troli7,$troli8,$troli9,$troli10]
onready var cArea = [$troli1/Area2D1,$troli2/Area2D2,$troli3/Area2D3,$troli4/Area2D4,$troli5/Area2D5,$troli6/Area2D6,$troli7/Area2D7,$troli8/Area2D8,$troli9/Area2D9,$troli10/Area2D10]
var mouseOnTroli = [false,false,false,false,false,false,false,false,false,false]
var mouseOnFreezer = [false,false,false,false,false,false,false,false,false,false]
var mouseOnKlik = [false,false,false,false,false,false,false,false,false,false]
var mouseOnTroliCek = [false,false,false,false,false,false,false,false,false,false]#pengecekan kedua letak mouse
onready var f = [$SSlot1,$SSlot2,$SSlot3,$SSlot4,$SSlot5,$SSlot6,$SSlot7,$SSlot8,$SSlot9,$SSlot10]
var freezeSlot = [0,0,0,0,0,0,0,0,0,0] # 0=kosong,1=lemuru,2=slengseng,3=tongkol
var ft = [preload("res:///assets/fLemuru.png"), preload("res:///assets/fSlengseng.png"),preload("res:///assets/fTongkol.png"),preload("res:///assets/fLemuru2.png"), preload("res:///assets/fSlengseng2.png"),preload("res:///assets/fTongkol2.png"),preload("res:///assets/fLemuru3.png"), preload("res:///assets/fSlengseng3.png"),preload("res:///assets/fTongkol3.png")]
var cekTimer = 0
var c = 0
var cCek = 0

func prepareDatabase():
	# Create gdsqlite instance
	db = SQLite.new()
	# Open the database
	if (not db.open_db("res://gasipela.db")):
		return;
	# Create table
	var query = "CREATE TABLE IF NOT EXISTS dbgame(userId INTEGER PRIMARY KEY, nama VARCHAR(20), pass VARCHAR(20), skor1 INTEGER, skor2 INTEGER);";
	if (not db.query(query)):
		return;

func _ready():
	#Database
	prepareDatabase()
	
	#menyembunyikan pause
	$NPause.hide()
	
	#reset level
	level = 1
	rtempplus = 1
	gameEnd = false
	gameEndCek = 0
	for i in range (0,10,1):
		t[i].show()
	
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
	if gameEndCek == 0:
		gameEnd()
	setLevel()
	gameTimer()
	if gameEnd == false:
		gerakTroli()
		posisiLoyang()
		if cCek == 1:
			cek()
		dragAndDrop()
		pendinginan()
		angkatLoyang()
		freezer()
	#Set Text Coin
	$StatusBar/LCoin.set_text(str(coin))
	$StatusBar/LLevel.set_text(str(level))
	$SSkor/LSkor.set_text(str(coin))
	pass

func gameEnd():
	var insertSkor
	if rmin == 0 && rsec == 0:
		rtempplus = 0
		gameEnd = true
		$SSkor.show()
		$NPause.hide()
		cSkor = coin * 10
		for i in range (0,10,1):
			t[i].hide()
			f[i].hide()
		insertSkor = db.query(str("INSERT INTO dbgame VALUES (null,'"+ str(Global.user)+"',null,'"+ str(cSkor)+"','0')"))
		gameEndCek = 1

func gameTimer():
	rtemp += rtempplus
	if rtemp == 50:
		rtemp = 0
		rsec -= 1
	if rsec < 0:
		rsec = 59
		rmin -= 1
	$StatusBar/LTimer.text = str(rmin) +":"+ str(rsec).pad_zeros(2)
	pass

func gerakTroli():
	for i in range(10,0,-1):
		if xTroli[i-1] < letakTroli[i-1]:
			xTroli[i-1] = xTroli[i-1] + level
			t[i-1].set_position(Vector2(xTroli[i-1],507))

func posisiLoyang():
	for i in range(0,10,1):
		if mouseOnTroli[i] == true:
			slot = i

func dragAndDrop():
	for i in range(0,10,1):
		if Input.is_action_pressed("lClick"):
			if c == 1:
				c = 2
			if mouseOnTroli[i] == true:
				mouseOnTroliCek[i] = true
				for k in range(0,10,1):
					cArea[k].hide()
		if Input.is_action_just_released("lClick"):
			if xTroli[i-1] >= letakTroli[i-1]:
				t[i].set_position(Vector2(xTroli[i],507)) #mengembalikan loyang
			mouseOnTroliCek[i] = false
			c = 1
			for k in range(0,10,1):
				cArea[k].show()
		if mouseOnTroliCek[i] == true:
			t[i].set_position(get_viewport().get_mouse_position())
	for j in range(0,10,1):
		if Input.is_action_just_released("lClick"):
			if mouseOnFreezer[j] == true:
				if cekJenisTroli > 0:
					cCek = 1
					freezeSlot[j] = cekJenisTroli
					x = -54
					for a in range (0,10,1):
						if xTroli[a] < x:
							x = xTroli[a]
					print(x)
					xTroli[slot] = x - 106
					for g in range(0,10,1):
						if letakTroliCek[g] < letakTroliCek[slot]:
							letakTroliCekTemp[g] = letakTroliCek[g] + 1
					letakTroliCekTemp[slot] = 0
					for h in range(0,10,1):
						letakTroliCek[h] = letakTroliCekTemp[h]
						letakTroli[h] = letakTroliAwal[letakTroliCek[h]]

func pendinginan():
	for i in range (0,10,1):
		if freezeSlot[i] == 1 or freezeSlot[i] == 4:
			if waktuSimpan[i] < 500 - waktuMinusSimpan[level-1]:
				waktuSimpan[i] += 1
			if waktuSimpan[i] == 250 - waktuMinusSimpan[level-1]:
				freezeSlot[i] = 4
			if waktuSimpan[i] == 500 - waktuMinusSimpan[level-1]:
				waktuSimpan[i] = 501 - waktuMinusSimpan[level-1]
				freezeSlot[i] = 7
		if freezeSlot[i] == 2 or freezeSlot[i] == 5:
			if waktuSimpan[i] < 500 - waktuMinusSimpan[level-1]:
				waktuSimpan[i] += 1
			if waktuSimpan[i] == 250 - waktuMinusSimpan[level-1]:
				freezeSlot[i] = 5
			if waktuSimpan[i] == 500 - waktuMinusSimpan[level-1]:
				waktuSimpan[i] = 501 - waktuMinusSimpan[level-1]
				freezeSlot[i] = 8
		if freezeSlot[i] == 3 or freezeSlot[i] == 6:
			if waktuSimpan[i] < 500 - waktuMinusSimpan[level-1]:
				waktuSimpan[i] += 1
			if waktuSimpan[i] == 250 - waktuMinusSimpan[level-1]:
				freezeSlot[i] = 6
			if waktuSimpan[i] == 500 - waktuMinusSimpan[level-1]:
				waktuSimpan[i] = 501 - waktuMinusSimpan[level-1]
				freezeSlot[i] = 9
		if freezeSlot[i] == 0:
			waktuSimpan[i] = 0

func angkatLoyang():
	for j in range(0,10,1):
		if mouseOnFreezer[j] == true:
			#Mengangkat loyang di freezer
			if Input.is_action_pressed("rClick"):
				if freezeSlot[j] != 1 && freezeSlot[j] != 2 && freezeSlot[j] != 3:
					if freezeSlot[j] == 4:
						coin += 15
					if freezeSlot[j] == 5:
						coin += 20
					if freezeSlot[j] == 6:
						coin += 10
					if freezeSlot[j] == 7:
						coin -= 15
					if freezeSlot[j] == 8:
						coin -= 20
					if freezeSlot[j] == 9:
						coin -= 10
					freezeSlot[j] = 0

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
		if freezeSlot[s] == 4:
			f[s].set_texture(ft[4-1])
			f[s].show()
		if freezeSlot[s] == 5:
			f[s].set_texture(ft[5-1])
			f[s].show()
		if freezeSlot[s] == 6:
			f[s].set_texture(ft[6-1])
			f[s].show()
		if freezeSlot[s] == 7:
			f[s].set_texture(ft[7-1])
			f[s].show()
		if freezeSlot[s] == 8:
			f[s].set_texture(ft[8-1])
			f[s].show()
		if freezeSlot[s] == 9:
			f[s].set_texture(ft[9-1])
			f[s].show()

func setLevel():
	if coin > 200:
		level = 2
	if coin > 500:
		level = 3

func cek():
	if cekTimer < 60:
		cekTimer += 1
	if cekTimer == 60:
		cekJenisTroli = 0
		cekTimer = 61
		c = 0
		cCek = 0

func _on_Area2D10_mouse_entered():
	mouseOnTroli[10-1] = true
	cekJenisTroli = 2
	c = 1
	pass
func _on_Area2D10_mouse_exited():
	mouseOnTroli[10-1] = false
	if c < 2: 
		cekJenisTroli = 0
		c = 0
	pass
func _on_Area2D9_mouse_entered():
	mouseOnTroli[9-1] = true
	cekJenisTroli = 1
	c = 1
	pass
func _on_Area2D9_mouse_exited():
	mouseOnTroli[9-1] = false
	if c < 2: 
		cekJenisTroli = 0
		c = 0
	pass
func _on_Area2D8_mouse_entered():
	mouseOnTroli[8-1] = true
	cekJenisTroli = 3
	c = 1
	pass
func _on_Area2D8_mouse_exited():
	mouseOnTroli[8-1] = false
	if c < 2: 
		cekJenisTroli = 0
		c = 0
	pass
func _on_Area2D7_mouse_entered():
	mouseOnTroli[7-1] = true
	cekJenisTroli = 1
	c = 1
	pass
func _on_Area2D7_mouse_exited():
	mouseOnTroli[7-1] = false
	if c < 2: 
		cekJenisTroli = 0
		c = 0
	pass
func _on_Area2D6_mouse_entered():
	mouseOnTroli[6-1] = true
	cekJenisTroli = 3
	c = 1
	pass
func _on_Area2D6_mouse_exited():
	mouseOnTroli[6-1] = false
	if c < 2: 
		cekJenisTroli = 0
		c = 0
	pass
func _on_Area2D5_mouse_entered():
	mouseOnTroli[5-1] = true
	cekJenisTroli = 2
	c = 1
	pass
func _on_Area2D5_mouse_exited():
	mouseOnTroli[5-1] = false
	if c < 2: 
		cekJenisTroli = 0
		c = 0
	pass
func _on_Area2D4_mouse_entered():
	mouseOnTroli[4-1] = true
	cekJenisTroli = 1
	c = 1
	pass
func _on_Area2D4_mouse_exited():
	mouseOnTroli[4-1] = false
	if c < 2: 
		cekJenisTroli = 0
		c = 0
	pass
func _on_Area2D3_mouse_entered():
	mouseOnTroli[3-1] = true
	cekJenisTroli = 1
	c = 1
	pass
func _on_Area2D3_mouse_exited():
	mouseOnTroli[3-1] = false
	if c < 2: 
		cekJenisTroli = 0
		c = 0
	pass
func _on_Area2D2_mouse_entered():
	mouseOnTroli[2-1] = true
	cekJenisTroli = 2
	c = 1
	pass
func _on_Area2D2_mouse_exited():
	mouseOnTroli[2-1] = false
	if c < 2: 
		cekJenisTroli = 0
		c = 0
	pass
func _on_Area2D1_mouse_entered():
	mouseOnTroli[1-1] = true
	cekJenisTroli = 1
	c = 1
	pass
func _on_Area2D1_mouse_exited():
	mouseOnTroli[1-1] = false
	if c < 2: 
		cekJenisTroli = 0
		c = 0
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
	if gameEnd == false:
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

func _on_BMainLagi_pressed():
	get_tree().change_scene("res://Penyimpanan.tscn")
