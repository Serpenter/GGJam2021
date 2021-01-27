extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _on_play_game_pressed():
	GSceneManager.goto_scene_wloader("res://main_scenes/main_game/main_game.tscn")
	pass # Replace with function body.


func _on_tutorial_pressed():
	GSceneManager.goto_scene_wloader("res://main_scenes/tutorial/tutorial.tscn")
	pass # Replace with function body.


func _on_exit_pressed():
	get_tree().quit()
