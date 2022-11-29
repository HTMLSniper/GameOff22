extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


var diver = preload("res://assets/diver.png")
var princess_crown = preload("res://assets/bombo_as_princess.png")
var crown = preload("res://assets/bombo_crowned.png")
var amongusfinalskin = preload("res://assets/AmongusFinalSkin.png")
# Called when the node enters the scene tree for the first time.
var cost_amongo = 10
var cost_crown = 2
var cost_princess = 4
var cost_diver = 5

func _ready():
	Global.load()
	$Camera2D.current = true
	Shake.set_cam()
	$Moneycoin/Moneylabel.text = String(Global.settings["coins"])
	$Diver/Coin/Costdiver.text = String(cost_diver)
	$amongo/Coin/Costamongo.text = String(cost_amongo)
	$"Princess as bombo/Coin/Costprincess".text = String(cost_princess)	
	$crown/Coin/Costcrown.text = String(cost_crown)
	_check_for_usage()
	
	
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
		if Global.settings["coins"] < cost_crown:
			$crown/Button_crown.disabled = true
		else: 
			$crown/Button_crown.disabled = false

func _on_Go_Back_pressed():
	Global.save()
	get_tree().change_scene("res://MainMenu.tscn")


func _on_Button_diver_pressed():
	if Global.settings["skin_diver"] == 1:
		Global.sprite_texture = diver
		Global.player.change_sprite(diver)
	else: 
		if Global.settings["coins"] >= cost_diver:
			Global.settings["coins"] = Global.settings["coins"] - cost_diver
			Global.sprite_texture = diver
			Global.player.change_sprite(diver)
			$Moneycoin/Moneylabel.text = String(Global.settings["coins"])
			Global.settings["skin_diver"] = 1
			$Diver/Button_diver.text = "Use"
			_check_for_usage()
		else:
			pass


func _on_Button_amongo_pressed():
	if Global.settings["skin_amongo"] == 1:
		Global.sprite_texture = amongusfinalskin
		Global.player.change_sprite(amongusfinalskin)
	else:
		if Global.settings["coins"] >= cost_amongo:
			Global.settings["coins"] = Global.settings["coins"] - cost_amongo
			Global.sprite_texture = amongusfinalskin
			Global.player.change_sprite(amongusfinalskin)
			$Moneycoin/Moneylabel.text = String(Global.settings["coins"])
			Global.settings["skin_amongo"] = 1
			$amongo/Button_amongo.text = "Use"
			_check_for_usage()
		else:
			pass

func _on_Button_crown_pressed():
	if Global.settings["skin_crown"] == 1:
		Global.sprite_texture = crown
		Global.player.change_sprite(crown)
	else:
		if Global.settings["coins"] >= cost_crown:
			Global.settings["coins"] = Global.settings["coins"] - cost_crown
			Global.sprite_texture = crown
			Global.player.change_sprite(crown)
			$Moneycoin/Moneylabel.text = String(Global.settings["coins"])
			Global.settings["skin_crown"] = 1
			$crown/Button_crown.text = "Use"
			_check_for_usage()
		else:
			pass


func _on_Button_princess_bombo_pressed():
	if Global.settings["skin_princess"] == 1:
			Global.sprite_texture = princess_crown
			Global.player.change_sprite(princess_crown)
	else:
		if Global.settings["coins"] >= cost_princess:
			Global.settings["coins"] = Global.settings["coins"] - cost_princess
			Global.sprite_texture = princess_crown
			Global.player.change_sprite(princess_crown)
			$Moneycoin/Moneylabel.text = String(Global.settings["coins"])
			Global.settings["skin_princess"] = 1
			$"Princess as bombo/Button_princess_bombo".text = "Use"
			_check_for_usage()
		else:
			pass
