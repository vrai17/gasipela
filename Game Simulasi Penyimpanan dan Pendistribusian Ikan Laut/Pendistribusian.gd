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
#Coin
var coin = 0
var cSkor
#LetakToko
var letakToko = 1
#Navigation Path
onready var pOrderL = [$PathLemuru1,$PathLemuru2,$PathLemuru3,$PathLemuru4,$PathLemuru5]
onready var pOrderS = [$PathSlengseng1,$PathSlengseng2,$PathSlengseng3,$PathSlengseng4,$PathSlengseng5]
onready var pOrderT = [$PathTongkol1,$PathTongkol2,$PathTongkol3,$PathTongkol4,$PathTongkol5]
onready var fOrderL = [$PathLemuru1/FollowLemuru1,$PathLemuru2/FollowLemuru2,$PathLemuru3/FollowLemuru3,$PathLemuru4/FollowLemuru4,$PathLemuru5/FollowLemuru5]
onready var fOrderS = [$PathSlengseng1/FollowSlengseng1,$PathSlengseng2/FollowSlengseng2,$PathSlengseng3/FollowSlengseng3,$PathSlengseng4/FollowSlengseng4,$PathSlengseng5/FollowSlengseng5]
onready var fOrderT = [$PathTongkol1/FollowTongkol1,$PathTongkol2/FollowTongkol2,$PathTongkol3/FollowTongkol3,$PathTongkol4/FollowTongkol4,$PathTongkol5/FollowTongkol5]
onready var sOrderL = [$PathLemuru1/FollowLemuru1/Sprite1,$PathLemuru2/FollowLemuru2/Sprite1,$PathLemuru3/FollowLemuru3/Sprite1,$PathLemuru4/FollowLemuru4/Sprite1,$PathLemuru5/FollowLemuru5/Sprite1]
onready var sOrderS = [$PathSlengseng1/FollowSlengseng1/Sprite1,$PathSlengseng2/FollowSlengseng2/Sprite1,$PathSlengseng3/FollowSlengseng3/Sprite1,$PathSlengseng4/FollowSlengseng4/Sprite1,$PathSlengseng5/FollowSlengseng5/Sprite1]
onready var sOrderT = [$PathTongkol1/FollowTongkol1/Sprite1,$PathTongkol2/FollowTongkol2/Sprite1,$PathTongkol3/FollowTongkol3/Sprite1,$PathTongkol4/FollowTongkol4/Sprite1,$PathTongkol5/FollowTongkol5/Sprite1]
var lPathLemuru = [528.5,1009.13,261.77,1028.23,769.2]
var lPathSlengseng = [714.41,824.6,451.38,847.49,591.79]
var lPathTongkol = [892.02,644.8,632.35,668.75,405.91]
var oL = [0,0,0,0,0]
var oS = [0,0,0,0,0]
var oT = [0,0,0,0,0]
var o = [0,0,0,0,0]
var order = [1,1,1,1,1]
var waktuOrder = [0,0,0,0,0]
var waktuOrderTemp = [0,0,0,0,0]
var waktuMinusOrder =[0,100,200]
var gameEnd = false
var gameEndCek = 0
onready var iOrder = [$IconOrder1,$IconOrder2,$IconOrder3,$IconOrder4,$IconOrder5]
var iOrderTexture = [preload("res://assets/IconOrderLemuru.png"),preload("res://assets/IconOrderSlengseng.png"),preload("res://assets/IconOrderTongkol.png")]

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

func reset():
	#Level
	level = 1
	gameEndCek = 0
	#Reset coin
	coin = 0
	cSkor = 0
	#Reset Offset
	for i in range (0,5,1):
		fOrderL[i].set_offset(0)
		fOrderS[i].set_offset(0)
		fOrderT[i].set_offset(0)
	#reset Toko
	$Background/STLemuru.show()
	$Background/STSlengseng.hide()
	$Background/STTongkol.hide()
	#reset Pause Popup
	$NPause.hide()
	
	#Hide Icon Order
	for i in range (0,5,1):
		iOrder[i].hide()
	#Hide Popup Skor
	$SSkor.hide()
	#Menjalankan waktu
	rtempplus = 1
	#Reset Game End
	gameEnd = false
	
func _ready():
	prepareDatabase()
	randomize()
	reset()
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
	gerakTruck(delta)
	gameTimer()
	pilihToko()
	setOrderTexture()
	if gameEnd == false:
		randomOrder()
	#Set Text Coin
	$StatusBar/LCoin.set_text(str(coin))
	$StatusBar/LLevel.set_text(str(level))
	$SSkor/LSkor.set_text(str(coin))
	pass
	
func setLevel():
	if coin > 200:
		level = 2
	if coin > 500:
		level = 3
	
func gameEnd():
	var insertSkor
	if rmin == 0 && rsec == 0:
		rtempplus = 0
		gameEnd = true
		cSkor = coin * 10
		$SSkor.show()
		$NPause.hide()
		for i in range (0,5,1):
			iOrder[i].hide()
		insertSkor = db.query(str("INSERT INTO dbgame VALUES (null,'"+ str(Global.user)+"',null,'0','"+ str(cSkor)+"')"))
		gameEndCek = 1
	
func pilihToko():
	if Input.is_action_pressed("press1") && gameEnd == false:
		letakToko = 1
		$Background/STLemuru.show()
		$Background/STSlengseng.hide()
		$Background/STTongkol.hide()
	if Input.is_action_pressed("press2") && gameEnd == false:
		letakToko = 2
		$Background/STLemuru.hide()
		$Background/STSlengseng.show()
		$Background/STTongkol.hide()
	if Input.is_action_pressed("press3") && gameEnd == false:
		letakToko = 3
		$Background/STLemuru.hide()
		$Background/STSlengseng.hide()
		$Background/STTongkol.show()

func setOrderTexture():
	for i in range (0,5,1):
		if order[i] == 1:
			iOrder[i].set_texture(iOrderTexture[0])
		elif order[i] == 2:
			iOrder[i].set_texture(iOrderTexture[1])
		elif order[i] == 3:
			iOrder[i].set_texture(iOrderTexture[2])

func randomOrder():
	#cooldown 10 12 15 8 14
	if waktuOrderTemp[0] < 500 - waktuMinusOrder[level-1]:
		waktuOrderTemp[0] += 1
	if waktuOrderTemp[0] == 500 - waktuMinusOrder[level-1]:
		waktuOrderTemp[0] = 501 - waktuMinusOrder[level-1]
		order[0] = randi()%3+1
		iOrder[0].show()
	#Order Toko 2 = 12 detik cooldown
	if waktuOrderTemp[1] < 600 - waktuMinusOrder[level-1]:
		waktuOrderTemp[1] += 1
	if waktuOrderTemp[1] == 600 - waktuMinusOrder[level-1]:
		waktuOrderTemp[1] = 601 - waktuMinusOrder[level-1]
		order[1] = randi()%3+1
		iOrder[1].show()
	#Order Toko 3 = 15 detik cooldown
	if waktuOrderTemp[2] < 750 - waktuMinusOrder[level-1]:
		waktuOrderTemp[2] += 1
	if waktuOrderTemp[2] == 750 - waktuMinusOrder[level-1]:
		waktuOrderTemp[2] = 751 - waktuMinusOrder[level-1]
		order[2] = randi()%3+1
		iOrder[2].show()
	#Order Toko 4 = 8 detik cooldown
	if waktuOrderTemp[3] < 400 - waktuMinusOrder[level-1]:
		waktuOrderTemp[3] += 1
	if waktuOrderTemp[3] == 400 - waktuMinusOrder[level-1]:
		waktuOrderTemp[3] = 401 - waktuMinusOrder[level-1]
		order[3] = randi()%3+1
		iOrder[3].show()
	#Order Toko 5 = 14 detik cooldown
	if waktuOrderTemp[4] < 700 - waktuMinusOrder[level-1]:
		waktuOrderTemp[4] += 1
	if waktuOrderTemp[4] == 700 - waktuMinusOrder[level-1]:
		waktuOrderTemp[4] = 701 - waktuMinusOrder[level-1]
		order[4] = randi()%3+1
		iOrder[4].show()
	pass
	
func gerakTruck(delta):
	for j in range (0,5,1):
		if oL[j] == 1:
			pOrderL[j].show()
			sOrderL[j].set_rotation(deg2rad(90))
			if fOrderL[j].get_offset() < lPathLemuru[j]:
				fOrderL[j].set_offset(fOrderL[j].get_offset() + 350 * delta)
		if fOrderL[j].get_offset() >= lPathLemuru[j]:
			oL[j] = 2
			sOrderL[j].set_rotation(deg2rad(-90))
		if oL[j] == 2:
			if fOrderL[j].get_offset() > 0:
				fOrderL[j].set_offset(fOrderL[j].get_offset() - 350 * delta)
		if fOrderL[j].get_offset() <= 0:
			oL[j] = 0
			pOrderL[j].hide()
			
	for j in range (0,5,1):
		if oS[j] == 1:
			pOrderS[j].show()
			sOrderS[j].set_rotation(deg2rad(90))
			if fOrderS[j].get_offset() < lPathSlengseng[j]:
				fOrderS[j].set_offset(fOrderS[j].get_offset() + 350 * delta)
		if fOrderS[j].get_offset() >= lPathSlengseng[j]:
			oS[j] = 2
			sOrderS[j].set_rotation(deg2rad(-90))
		if oS[j] == 2:
			if fOrderS[j].get_offset() > 0:
				fOrderS[j].set_offset(fOrderS[j].get_offset() - 350 * delta)
		if fOrderS[j].get_offset() <= 0:
			oS[j] = 0
			pOrderS[j].hide()
			
	for j in range (0,5,1):
		if oT[j] == 1:
			pOrderT[j].show()
			sOrderT[j].set_rotation(deg2rad(90))
			if fOrderT[j].get_offset() < lPathTongkol[j]:
				fOrderT[j].set_offset(fOrderT[j].get_offset() + 350 * delta)
				print(str(fOrderT[j].get_offset()))
		if fOrderT[j].get_offset() >= lPathTongkol[j]:
			print(str(fOrderT[j].get_offset()))
			oT[j] = 2
			sOrderT[j].set_rotation(deg2rad(-90))
		if oT[j] == 2:
			if fOrderT[j].get_offset() > 0:
				fOrderT[j].set_offset(fOrderT[j].get_offset() - 350 * delta)
		if fOrderT[j].get_offset() <= 0:
			oT[j] = 0
			pOrderT[j].hide()
			
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

func _on_BOrder1_pressed():
	if letakToko == 1:
		oL[0] = 1
		if order[0] == 1:
			coin += 15
		elif order[0] == 2:
			coin -= 15
		elif order[0] == 3:
			coin -= 15
	elif letakToko == 2:
		oS[0] = 1
		if order[0] == 1:
			coin -= 20
		elif order[0] == 2:
			coin += 20
		elif order[0] == 3:
			coin -= 20
	elif letakToko == 3:
		oT[0] = 1
		if order[0] == 1:
			coin -= 10
		elif order[0] == 2:
			coin -= 10
		elif order[0] == 3:
			coin += 10
	iOrder[0].hide()
	waktuOrderTemp[0] = 0
func _on_BOrder2_pressed():
	if letakToko == 1:
		oL[1] = 1
		if order[1] == 1:
			coin += 15
		elif order[1] == 2:
			coin -= 15
		elif order[1] == 3:
			coin -= 15
	elif letakToko == 2:
		oS[1] = 1
		if order[1] == 1:
			coin -= 20
		elif order[1] == 2:
			coin += 20
		elif order[1] == 3:
			coin -= 20
	elif letakToko == 3:
		oT[1] = 1
		if order[1] == 1:
			coin -= 10
		elif order[1] == 2:
			coin -= 10
		elif order[1] == 3:
			coin += 10
	iOrder[1].hide()
	waktuOrderTemp[1] = 0
func _on_BOrder3_pressed():
	if letakToko == 1:
		oL[2] = 1
		if order[2] == 1:
			coin += 15
		elif order[2] == 2:
			coin -= 15
		elif order[2] == 3:
			coin -= 15
	elif letakToko == 2:
		oS[2] = 1
		if order[2] == 1:
			coin -= 20
		elif order[2] == 2:
			coin += 20
		elif order[2] == 3:
			coin -= 20
	elif letakToko == 3:
		oT[2] = 1
		if order[2] == 1:
			coin -= 10
		elif order[2] == 2:
			coin -= 10
		elif order[2] == 3:
			coin += 10
	iOrder[2].hide()
	waktuOrderTemp[2] = 0
func _on_BOrder4_pressed():
	if letakToko == 1:
		oL[3] = 1
		if order[3] == 1:
			coin += 15
		elif order[3] == 2:
			coin -= 15
		elif order[3] == 3:
			coin -= 15
	elif letakToko == 2:
		oS[3] = 1
		if order[3] == 1:
			coin -= 20
		elif order[3] == 2:
			coin += 20
		elif order[3] == 3:
			coin -= 20
	elif letakToko == 3:
		oT[3] = 1
		if order[3] == 1:
			coin -= 10
		elif order[3] == 2:
			coin -= 10
		elif order[3] == 3:
			coin += 10
	iOrder[3].hide()
	waktuOrderTemp[3] = 0
func _on_BOrder5_pressed():
	if letakToko == 1:
		oL[4] = 1
		if order[4] == 1:
			coin += 15
		elif order[4] == 2:
			coin -= 15
		elif order[4] == 3:
			coin -= 15
	elif letakToko == 2:
		oS[4] = 1
		if order[4] == 1:
			coin -= 20
		elif order[4] == 2:
			coin += 20
		elif order[4] == 3:
			coin -= 20
	elif letakToko == 3:
		oT[4] = 1
		if order[4] == 1:
			coin -= 10
		elif order[4] == 2:
			coin -= 10
		elif order[4] == 3:
			coin += 10
	iOrder[4].hide()
	waktuOrderTemp[4] = 0

func _on_BMenu_pressed():
	if gameEnd == false:
		$NPause.show()
func _on_BKembali_pressed():
	$NPause.hide()
func _on_BRestart_pressed():
	get_tree().change_scene("res://Pendistribusian.tscn")
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
	get_tree().change_scene("res://Pendistribusian.tscn")
