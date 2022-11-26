extends Node

var player : KinematicBody2D
var coins = 0
var timeh = 0
var timem = 0
var times = 0
var jumps = 0
var falls = 0
var goal : Node2D


func reg_player(node):
	player = node

func reg_goal(node):
	goal = node
