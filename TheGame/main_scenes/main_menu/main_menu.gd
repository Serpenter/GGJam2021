extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(Array, String) var level_names
export(Array, String) var level_path

onready var levels_ui = $CanvasLayer/MarginContainer/HBoxContainer/Levels
onready var menu_ui = $CanvasLayer/MarginContainer/HBoxContainer/MenuButtons

var level_selector_prefab = preload("res://prefab_scenes/LevelSelectorButton/LevelSelectorButton.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
    pass

    if len(level_names) != len(level_path):
        print("Level names and level pathes should be the same length!")
    else:
        for i in range(len(level_names)):
            var new_button = level_selector_prefab.instance()
            levels_ui.add_child(new_button)
            new_button.text = level_names[i]
            new_button.stored_level_name = level_path[i]
            new_button.connect("selected", self, "_on_level_selected")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _on_play_game_pressed():
    GSceneManager.goto_scene_wloader("res://main_scenes/main_game/main_game.tscn")
    pass # Replace with function body.


func _on_tutorial_pressed():
    GSceneManager.goto_scene_wloader("res://test_scenes/tile_snap/tile_snap.tscn")
    pass # Replace with function body.


func _on_exit_pressed():
    get_tree().quit()


func _on_level_selected(level):
    GSceneManager.goto_scene_wloader(level)


func _on_level_selector_pressed():
    menu_ui.hide()
    levels_ui.show()


func _on_Return_pressed():
    menu_ui.show()
    levels_ui.hide()
