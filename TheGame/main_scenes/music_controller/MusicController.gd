extends Control


onready var game_music_1 = $GameMusic1
onready var game_music_2 = $GameMusic2
onready var main_menu_music = $MainMenuMusic

export var is_music_on = true
var is_playing_main_menu_music = true
# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass

func disable_music():
    is_music_on = false
    stop()
    
func enable_music(is_main_menu):
    is_music_on = true
    if is_main_menu:
        play_main_menu_music()
    else:
        play_game_music()
    

func stop():
    main_menu_music.stop()
    game_music_1.stop()
    game_music_2.stop()

func play_main_menu_music():
    is_playing_main_menu_music = true
    if not is_music_on:
        stop()
        return

    game_music_1.stop()
    game_music_2.stop()

    if main_menu_music.playing:
        return
    
    main_menu_music.play()

func play_game_music():
    is_playing_main_menu_music = false
    if not is_music_on:
        stop()
        return

    main_menu_music.stop()

    if game_music_2.playing or game_music_1.playing:
        return
    
    game_music_1.play()


func _on_GameMusic1_finished():
    if is_playing_main_menu_music:
        return

    if not is_music_on:
        stop()
        return
        
    game_music_2.play()


func _on_GameMusic2_finished():
    if is_playing_main_menu_music:
        return

    if not is_music_on:
        stop()
        return
        
    game_music_1.play()


func _on_MainMenuMusic_finished():
    if not is_playing_main_menu_music:
        return

    if not is_music_on:
        stop()
        return
        
    main_menu_music.play()
