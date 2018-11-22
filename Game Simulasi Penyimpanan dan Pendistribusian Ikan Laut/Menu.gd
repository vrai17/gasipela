extends Node2D

const SQLite = preload("res://lib/gdsqlite.gdns")
var db #temp sqlite
var iSkor1
var iSkor2
var nama2

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

func resetMusic():
	if Global.musik == 1:
		$NMenuAwal/BSoundOn.show()
		$NMenuAwal/BSoundOff.hide()
	else:
		$NMenuAwal/BSoundOff.show()
		$NMenuAwal/BSoundOn.hide()

func _ready():
	prepareDatabase()
	resetMusic()
	importSkor()
	startScene()
	
	if Global.login == 1 && Global.musik == 1:
		$Backsound.play()
	pass
	
func startScene():
	# Menampilkan dan menyembunyikan scene awal pemulaian
	if Global.login == 0:
		$NMenuLogin.show()
		$NMenuAwal.hide()
	else:
		$NMenuLogin.hide()
		$NMenuAwal.show()
	$NMenuJenis.hide()
	$NAbout.hide()
	$NSkor.hide()
	
func importSkor():
	var skorPenyimpanan = get_node("NSkor/SkorPenyimpanan")
	var skorPengiriman = get_node("NSkor/SkorPengiriman")
	var skorNama = get_node("NSkor/SkorNama")
	var skorNama2 = get_node("NSkor/SkorNama2")
	var tulisSkor1 = [0,0,0,0,0,0]
	var tulisSkor2 = [0,0,0,0,0,0]
	var tulisNama = ["Player1","Player2","Player3","Player4","Player5","Player6"]
	var tulisNama2 = ["Player1","Player2","Player3","Player4","Player5","Player6"]
	var importSkor1 = db.fetch_array("SELECT skor1 FROM dbgame ORDER BY skor1 DESC LIMIT 6;")
	var importSkor2 = db.fetch_array("SELECT skor2 FROM dbgame ORDER BY skor2 DESC LIMIT 6;")
	var importNama = db.fetch_array("SELECT nama FROM dbgame ORDER BY skor1 DESC LIMIT 6;")
	var importNama2 = db.fetch_array("SELECT nama FROM dbgame ORDER BY skor2 DESC LIMIT 6;")
	for i in range (0,6,1):
		if (importSkor1 and not importSkor1.empty()):
			tulisSkor1[i] = importSkor1[i]['skor1'];
		skorPenyimpanan.text = str(tulisSkor1[0])+"\n"+str(tulisSkor1[1])+"\n"+str(tulisSkor1[2])+"\n"+str(tulisSkor1[3])+"\n"+str(tulisSkor1[4])+"\n"+str(tulisSkor1[5])
	for i in range (0,6,1):
		if (importSkor2 and not importSkor2.empty()):
			tulisSkor2[i] = importSkor2[i]['skor2'];
		skorPengiriman.text = str(tulisSkor2[0])+"\n"+str(tulisSkor2[1])+"\n"+str(tulisSkor2[2])+"\n"+str(tulisSkor2[3])+"\n"+str(tulisSkor2[4])+"\n"+str(tulisSkor2[5])
	for j in range (0,6,1):
		if (importNama and not importNama.empty()):
			tulisNama[j] = importNama[j]['nama'];
		skorNama.text = str(tulisNama[0])+"\n"+str(tulisNama[1])+"\n"+str(tulisNama[2])+"\n"+str(tulisNama[3])+"\n"+str(tulisNama[4])+"\n"+str(tulisNama[5])
	for j in range (0,6,1):
		if (importNama2 and not importNama2.empty()):
			tulisNama2[j] = importNama2[j]['nama'];
		skorNama2.text = str(tulisNama2[0])+"\n"+str(tulisNama2[1])+"\n"+str(tulisNama2[2])+"\n"+str(tulisNama2[3])+"\n"+str(tulisNama2[4])+"\n"+str(tulisNama2[5])
	pass

func _on_BDaftar_pressed():
	var getNama = get_node("NMenuLogin/TNama").text
	var getPass = get_node("NMenuLogin/TPassword").text
	var klikDaftar = db.fetch_array(str("SELECT * FROM dbgame Where nama='" + str(getNama) +"' "))
	if getNama or getPass != "":
		if len(klikDaftar) > 0:
			$NMenuLogin/PNamaSama.show()
		else:
			var klikDaftar2 = db.query(str("INSERT INTO dbgame VALUES (null,'"+ str(getNama)+"','" + str(getPass)+"','0','0')"))
			klikDaftar = db.fetch_array(str("SELECT * FROM dbgame Where nama='" + str(getNama) +"' "))
			if (klikDaftar and not klikDaftar.empty()):
				nama2 = klikDaftar[0]['nama']
				$NMenuAwal/LUser.text = str(nama2)
				iSkor1 = klikDaftar[0]['skor1']
				$NMenuAwal/LSkorPenyimpanan.text = str(iSkor1)
				iSkor2 = klikDaftar[0]['skor2']
				$NMenuAwal/LSkorPengiriman.text = str(iSkor2)
			$NMenuLogin.hide()
			$NMenuAwal.show()
		
			#Menyimpan status login
			Global.login = 1
			#Play backsound
			if Global.login == 1 && Global.musik == 1:
				$Backsound.play()
	else:
		$NMenuLogin/PNamaKosong.show()

func _on_BLogin_pressed():
	var getNama2 = get_node("NMenuLogin/TNama").text
	var getPass2 = get_node("NMenuLogin/TPassword").text
	var klikLogin = db.fetch_array(str("SELECT * FROM dbgame Where nama='" + str(getNama2) +"' and pass='" + str(getPass2) +"' "))
	var klikLoginUser = db.fetch_array(str("SELECT * FROM dbgame Where nama='" + str(getNama2) +"'  "))
	var klikLoginPass = db.fetch_array(str("SELECT * FROM dbgame Where pass='" + str(getPass2) +"'  "))
	if getNama2 or getPass2 != "":
		if len(klikLoginUser) > 0:
			if len(klikLogin) > 0:
				$NMenuLogin.hide()
				$NMenuAwal.show()
				$NMenuAwal/LUser
				# Retrieve current highscore
				if (klikLogin and not klikLogin.empty()):
					nama2 = klikLogin[0]['nama']
					$NMenuAwal/LUser.text = str(nama2)
					iSkor1 = klikLogin[0]['skor1']
					$NMenuAwal/LSkorPenyimpanan.text = str(iSkor1)
					iSkor2 = klikLogin[0]['skor2']
					$NMenuAwal/LSkorPengiriman.text = str(iSkor2)
					#Menyimpan status login
					Global.login = 1
					#Play Backsound
					if Global.login == 1 && Global.musik == 1:
						$Backsound.play()
			else:
				$NMenuLogin/PPassSalah.show()
		else:
			$NMenuLogin/PUserSalah.show()
	else:
		$NMenuLogin/PNamaKosong.show()
	pass
	
func _on_BSoundOn_pressed():
	$NMenuAwal/BSoundOff.show()
	$NMenuAwal/BSoundOn.hide()
	Global.musik = 0
	$Backsound.stop()

func _on_BSoundOff_pressed():
	$NMenuAwal/BSoundOn.show()
	$NMenuAwal/BSoundOff.hide()
	Global.musik = 1
	$Backsound.play()
	
func _on_BExit_pressed():
	# Close database
	if (db and db.loaded()):
		db.close();
	get_tree().quit()
	
func _on_BPlay_pressed():
	$NMenuAwal.hide()
	$NMenuJenis.show()
	
func _on_BKembali_pressed():
	$NMenuJenis.hide()
	$NAbout.hide()
	$NSkor.hide()
	$NMenuAwal.show()
	
func _on_BAbout_pressed():
	$NMenuAwal.hide()
	$NAbout.show()
	
func _on_BRanking_pressed():
	$NMenuAwal.hide()
	$NSkor.show()
	
func _on_BLogout_pressed():
	$NMenuLogin/TNama.text = ""
	$NMenuLogin/TPassword.text = ""
	$NMenuAwal.hide()
	$NMenuLogin.show()
	#Menyimpan status login
	Global.login = 0
	$Backsound.stop()

func _on_BPenyimpanan_pressed():
	get_tree().change_scene("res://Penyimpanan.tscn")
	pass

func _on_BOkNamaSama_pressed():
	$NMenuLogin/TNama.text = ""
	$NMenuLogin/TPassword.text = ""
	$NMenuLogin/PNamaSama.hide()

func _on_BOkPassSalah_pressed():
	$NMenuLogin/TNama.text = ""
	$NMenuLogin/TPassword.text = ""
	$NMenuLogin/PPassSalah.hide()

func _on_BDistribusi_pressed():
	get_tree().change_scene("res://Pendistribusian.tscn")
	pass

func _on_BOkNamaKosong_pressed():
	$NMenuLogin/TNama.text = ""
	$NMenuLogin/TPassword.text = ""
	$NMenuLogin/PNamaKosong.hide()


func _on_BOkUserSalah_pressed():
	$NMenuLogin/TNama.text = ""
	$NMenuLogin/TPassword.text = ""
	$NMenuLogin/PUserSalah.hide()