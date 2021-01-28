extends Node2D


var is_paused = false
var is_launched = false

onready var victory_label = $CanvasLayer/Control/UpperCentralMarginContainer/VBoxContainer/VictoryLabel
onready var launch_button = $CanvasLayer/Control/UpperCentralMarginContainer/VBoxContainer/LaunchButton
onready var reset_button = $CanvasLayer/Control/UpperCentralMarginContainer/VBoxContainer/ResetButton

onready var victory_zones = get_tree().get_nodes_in_group("VictoryZone")

# Called when the node enters the scene tree for the first time.
func _ready():
#	pause_game()
	pass


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
	is_launched = false
	victory_label.visible = false
	get_tree().call_group("Resetable", "load_saved_state")
	launch_button.disabled = false

func _on_LaunchButton_pressed():
	if is_launched:
		return

	var launchable_list = get_tree().get_nodes_in_group("ShouldLaunch")
	
	for launchable in launchable_list:
		if not launchable.can_launch():
			# add some popup
			# or maybe have some default impulse for all balls
			return
			
	var resatable_list = get_tree().get_nodes_in_group("Resetable")
	
	for resetable in resatable_list:
		if resetable.has_method("save_initial_state"):
			resetable.save_initial_state()
# 	don't use call group, it doesn't work instantly
#	get_tree().call_group("Resetable", "save_initial_state")
			
		
	is_launched = true
	for launchable in launchable_list:
		launchable.initial_launch()
		
	launch_button.disabled = true
	reset_button.disabled = false

func _on_ResetButton_pressed():
	on_level_restart()
