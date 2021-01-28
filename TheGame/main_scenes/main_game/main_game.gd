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


func _on_to_main_menu_pressed():
    GSceneManager.goto_scene_wloader("res://main_scenes/main_menu/main_menu.tscn")
