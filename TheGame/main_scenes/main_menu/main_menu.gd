extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(Array, String) var level_names
export(Array, String) var level_path

export(Array, String) var tutorial_names
export(Array, String) var tutorial_path

onready var levels_ui = $CanvasLayer/MarginContainer/HBoxContainer/Levels
onready var tutorials_ui = $CanvasLayer/MarginContainer/HBoxContainer/Tutorials
onready var menu_ui = $CanvasLayer/MarginContainer/HBoxContainer/MenuButtons
onready var options_ui = $CanvasLayer/MarginContainer/HBoxContainer/Options
onready var options_music_button = $CanvasLayer/MarginContainer/HBoxContainer/Options/Music
onready var options_sound_button = $CanvasLayer/MarginContainer/HBoxContainer/Options/Sound
onready var controls_panel = $CanvasLayer/MarginContainer/HBoxContainer/Controls

var level_selector_prefab = preload("res://prefab_scenes/LevelSelectorButton/LevelSelectorButton.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
    update_options_visualization()
    MusicController.play_main_menu_music()

    attach_levels(level_names, level_path, levels_ui, "_on_level_selected")
    attach_levels(tutorial_names, tutorial_path, tutorials_ui, "_on_tutorial_selected")




# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _on_play_game_pressed():
    GSceneManager.goto_scene_wloader("res://main_scenes/levels/level_k_01/LevelK01.tscn")
    pass # Replace with function body.


func _on_tutorial_pressed():
    menu_ui.hide()
    tutorials_ui.show()


func _on_exit_pressed():
    get_tree().quit()


func _on_level_selected(level):
    GSceneManager.goto_scene_wloader(level)

func _on_tutorial_selected(level):
    GSceneManager.goto_scene_wloader(level)

func _on_level_selector_pressed():
    menu_ui.hide()
    levels_ui.show()


func _on_Return_pressed():
    menu_ui.show()
    levels_ui.hide()
    tutorials_ui.hide()
    options_ui.hide()
    controls_panel.hide()


func _on_options_selector_pressed():
    menu_ui.hide()
    options_ui.show()

func update_options_visualization():
    if MusicController.is_music_on:
        options_music_button.text = "Music: ON"
    else:
        options_music_button.text = "Music: OFF"
        
    if MusicController.is_sound_on:
        options_sound_button.text = "Sound: ON"
    else:
        options_sound_button.text = "Sound: OFF"


func _on_Sound_pressed():
    MusicController.toggle_sound()
    update_options_visualization()


func _on_Music_pressed():
    MusicController.toggle_music()
    update_options_visualization()

func attach_levels(names, pathes, control, signal_name):
    if len(names) != len(pathes):
        print("Level names and level pathes should be the same length!")
    else:
        for i in range(len(names)):
            var new_button = level_selector_prefab.instance()
            control.add_child(new_button)
            new_button.text = names[i]
            new_button.stored_level_name = pathes[i]
            new_button.connect("selected", self, signal_name)


func _on_controls_pressed():
    controls_panel.show()
    menu_ui.hide()


func _on_sandbox_pressed():
    GSceneManager.goto_scene_wloader("res://main_scenes/levels/level_k_01/LevelK01.tscn")
