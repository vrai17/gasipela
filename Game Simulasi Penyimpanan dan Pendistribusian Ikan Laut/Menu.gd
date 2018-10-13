extends Node2D

func _ready():
	$NMenuLogin.show()
	$NMenuAwal.hide()
	$NMenuJenis.hide()
	$NAbout.hide()
	$NSkor.hide()

func _on_BLogin_pressed():
	$NMenuLogin.hide()
	$NMenuAwal.show()
func _on_BDaftar_pressed():
	$NMenuLogin.hide()
	$NMenuAwal.show()
func _on_BExit_pressed():
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
	$NMenuAwal.hide()
	$NMenuLogin.show()
