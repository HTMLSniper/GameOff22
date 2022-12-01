extends Node2D


var bombo_mario = preload("res://assets/bombo_mario.png")
var bombo = preload("res://assets/bombo.png")
var diver = preload("res://assets/diver.png")
var princess_crown = preload("res://assets/bombo_as_princess.png")
var crown = preload("res://assets/bombo_crowned.png")
var amongusfinalskin = preload("res://assets/AmongusFinalSkin.png")

onready var click_sound = $AudioStreamPlayer

var cost_amongo = 4
var cost_princess = 3
var cost_diver = 3
var cost_mario = 5

func _ready():
	Global.load()
	$Camera2D.current = true
	Shake.set_cam()
	$Moneycoin/Moneylabel.text = String(Global.settings["coins"])
	$Diver/Coin/Costdiver.text = String(cost_diver)
	$amongo/Coin/Costamongo.text = String(cost_amongo)
	$"Princess as bombo/Coin/Costprincess".text = String(cost_princess)	
	$bombo_mario/Coin/Costbombo_mario.text = String(cost_mario)
	change_button_color()
	_check_for_usage()
	Global.connect("sound_changed_live", self, "sound_changed")
	Global.connect("music_changed_live", self, "music_changed")
	
	
func _check_for_usage():

	if Global.settings["skin_amongo"] == 1:
		$amongo/Button_amongo.text = "Use"
	else:
		if Global.settings["coins"] < cost_amongo:
			$amongo/Button_amongo.disabled = true
		else: 
			$amongo/Button_amongo.disabled = false
			
	if Global.settings["skin_diver"] == 1:
		$Diver/Button_diver.text = "Use"
	else:
		if Global.settings["coins"] < cost_diver:
			$Diver/Button_diver.disabled = true
		else: 
			$Diver/Button_diver.disabled = false
			
	if Global.settings["skin_princess"] == 1:
		$"Princess as bombo/Button_princess_bombo".text = "Use"
	else:
		if Global.settings["coins"] < cost_princess:
			$"Princess as bombo/Button_princess_bombo".disabled = true
		else: 
			$"Princess as bombo/Button_princess_bombo".disabled = false
			
	if Global.settings["skin_crown"] == 1:
		$crown/Button_crown.text = "Use"
	else:
		if Global.settings["skin_crown"] == 0:
			$crown/Button_crown.disabled = true
		else: 
			$crown/Button_crown.disabled = false
	if Global.settings["skin_mario"] == 1:
		$bombo_mario/Button_bombo_mario.text = "Use"
	else:
		if Global.settings["coins"] < cost_mario:
			$bombo_mario/Button_bombo_mario.disabled = true
		else: 
			$bombo_mario/Button_bombo_mario.disabled = false		
			
			
		
func change_button_color():
	if Global.sprite_texture == diver:
		$Diver/Button_diver.set_self_modulate("00910c")
		$crown/Button_crown.set_self_modulate("ffffff")
		$bombo_mario/Button_bombo_mario.set_self_modulate("ffffff")
		$"Princess as bombo/Button_princess_bombo".set_self_modulate("ffffff")
		$amongo/Button_amongo.set_self_modulate("ffffff")
		$Use_default_skin.set_self_modulate("ffffff")
	if Global.sprite_texture == crown:
		$Diver/Button_diver.set_self_modulate("ffffff")
		$crown/Button_crown.set_self_modulate("00910c")
		$bombo_mario/Button_bombo_mario.set_self_modulate("ffffff")
		$"Princess as bombo/Button_princess_bombo".set_self_modulate("ffffff")
		$amongo/Button_amongo.set_self_modulate("ffffff")
		$Use_default_skin.set_self_modulate("ffffff")
	if Global.sprite_texture == bombo_mario:
		$Diver/Button_diver.set_self_modulate("ffffff")
		$crown/Button_crown.set_self_modulate("ffffff")
		$bombo_mario/Button_bombo_mario.set_self_modulate("00910c")
		$"Princess as bombo/Button_princess_bombo".set_self_modulate("ffffff")
		$amongo/Button_amongo.set_self_modulate("ffffff")
		$Use_default_skin.set_self_modulate("ffffff")
	if Global.sprite_texture == princess_crown:
		$Diver/Button_diver.set_self_modulate("ffffff")
		$crown/Button_crown.set_self_modulate("ffffff")
		$bombo_mario/Button_bombo_mario.set_self_modulate("ffffff")
		$"Princess as bombo/Button_princess_bombo".set_self_modulate("00910c")
		$amongo/Button_amongo.set_self_modulate("ffffff")
		$Use_default_skin.set_self_modulate("ffffff") 
	if Global.sprite_texture == amongusfinalskin:
		$Diver/Button_diver.set_self_modulate("ffffff")
		$crown/Button_crown.set_self_modulate("ffffff")
		$bombo_mario/Button_bombo_mario.set_self_modulate("ffffff")
		$"Princess as bombo/Button_princess_bombo".set_self_modulate("ffffff")
		$amongo/Button_amongo.set_self_modulate("00910c")
		$Use_default_skin.set_self_modulate("ffffff")
	if Global.sprite_texture == bombo:
		$Diver/Button_diver.set_self_modulate("ffffff")
		$crown/Button_crown.set_self_modulate("ffffff")
		$bombo_mario/Button_bombo_mario.set_self_modulate("ffffff")
		$"Princess as bombo/Button_princess_bombo".set_self_modulate("ffffff")
		$amongo/Button_amongo.set_self_modulate("ffffff")
		$Use_default_skin.set_self_modulate("00910c")

func music_changed():
	pass

func sound_changed():
	if Global.sound_on:
		click_sound.volume_db = Global.sound_vol
	else:
		click_sound.volume_db = -80

func _on_Use_default_skin_pressed():
	click_sound.pitch_scale = rand_range(0.5,2.5)
	sound_changed()
	click_sound.play()
	Global.sprite_texture = bombo
	Global.player.change_sprite(bombo)
	change_button_color()
	
	
func _on_Go_Back_pressed():
	click_sound.pitch_scale = rand_range(0.5,2.5)
	sound_changed()
	click_sound.play()
	Global.save()
	get_tree().change_scene("res://MainMenu.tscn")

func _on_Button_diver_pressed():
	click_sound.pitch_scale = rand_range(0.5,2.5)
	sound_changed()
	click_sound.play()
	if Global.settings["skin_diver"] == 1:
		Global.sprite_texture = diver
		Global.player.change_sprite(diver)
		change_button_color()
	else: 
		if Global.settings["coins"] >= cost_diver:
			Global.change_coins(Global.settings["coins"] - cost_diver)
			Global.sprite_texture = diver
			Global.player.change_sprite(diver)
			$Moneycoin/Moneylabel.text = String(Global.settings["coins"])
			Global.settings["skin_diver"] = 1
			$Diver/Button_diver.text = "Use"
			_check_for_usage()
			change_button_color()
		else:
			pass

func _on_Button_amongo_pressed():
	click_sound.pitch_scale = rand_range(0.5,2.5)
	sound_changed()
	click_sound.play()
	if Global.settings["skin_amongo"] == 1:
		Global.sprite_texture = amongusfinalskin
		Global.player.change_sprite(amongusfinalskin)
		change_button_color()
	else:
		if Global.settings["coins"] >= cost_amongo:
			Global.change_coins(Global.settings["coins"] - cost_amongo)
			Global.sprite_texture = amongusfinalskin
			Global.player.change_sprite(amongusfinalskin)
			$Moneycoin/Moneylabel.text = String(Global.settings["coins"])
			Global.settings["skin_amongo"] = 1
			$amongo/Button_amongo.text = "Use"
			_check_for_usage()
			change_button_color()
		else:
			pass

func _on_Button_crown_pressed():
	click_sound.pitch_scale = rand_range(0.5,2.5)
	sound_changed()
	click_sound.play()
	if Global.settings["skin_crown"] == 1:
		Global.sprite_texture = crown
		Global.player.change_sprite(crown)
		_check_for_usage()
		change_button_color()
	else:
		pass

func _on_Button_princess_bombo_pressed():
	click_sound.pitch_scale = rand_range(0.5,2.5)
	sound_changed()
	click_sound.play()
	if Global.settings["skin_princess"] == 1:
			Global.sprite_texture = princess_crown
			Global.player.change_sprite(princess_crown)
			change_button_color()
	else:
		if Global.settings["coins"] >= cost_princess:
			Global.change_coins(Global.settings["coins"] - cost_princess)
			Global.sprite_texture = princess_crown
			Global.player.change_sprite(princess_crown)
			$Moneycoin/Moneylabel.text = String(Global.settings["coins"])
			Global.settings["skin_princess"] = 1
			$"Princess as bombo/Button_princess_bombo".text = "Use"
			_check_for_usage()
			change_button_color()
		else:
			pass

func _on_Button_bombo_mario_pressed():
	click_sound.pitch_scale = rand_range(0.5,2.5)
	sound_changed()
	click_sound.play()
	if Global.settings["skin_mario"] == 1:
			Global.sprite_texture = bombo_mario
			Global.player.change_sprite(bombo_mario)
			change_button_color()
	else:
		if Global.settings["coins"] >= cost_mario:
			Global.change_coins(Global.settings["coins"] - cost_mario)
			Global.sprite_texture = bombo_mario
			Global.player.change_sprite(bombo_mario)
			$Moneycoin/Moneylabel.text = String(Global.settings["coins"])
			Global.settings["skin_mario"] = 1
			$bombo_mario/Button_bombo_mario.text = "Use"
			_check_for_usage()
			change_button_color()
		else:
			pass
