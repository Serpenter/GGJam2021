extends Node2D


var is_paused = false

onready var victory_label = $CanvasLayer/Control/UpperCentralMarginContainer/VBoxContainer/VictoryLabel

onready var victory_zones = get_tree().get_nodes_in_group("VictoryZone")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
#	pause_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func pause_game():
	get_tree().paused = true
	

func unpause_game():
	get_tree().paused = false
	

func is_victory():
	for zone in victory_zones:
		if not zone.is_activated:
			return false
	
	return true

func on_zone_activated(zone):
	if is_victory():
		on_victory()

func on_victory():
	victory_label.visible = true

func on_level_restart():
	victory_label.visible = false
	

func _on_StartButton_pressed():
	var balls = get_tree().get_nodes_in_group("Ball")
	
	for ball in balls:
		if not ball.can_launch():
			# add some popup
			# or maybe have some default impulse for all balls
			return
	
	for ball in balls:
		ball.initial_launch()
	


func _on_RestartButton_pressed():
	GSceneManager.goto_scene_wloader("res://test_scenes/TestLevel01/TestLevel01.tscn")
