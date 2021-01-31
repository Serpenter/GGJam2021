extends Node2D


var is_paused = false
var is_launched = false

# equals or more
export(int) var captured_cats_to_win = 1

# equals or less
export(int) var free_cats_to_win = 0
# equals or more
export(int) var free_cats_to_fail = 100

# equals or more
export(int) var dead_cats_to_fail = 100
# equals or more
export(int) var dead_cats_to_bad_level = 1

export(String) var next_level_path = "res://main_scenes/main_menu/main_menu.tscn"

# Cat stats
var free_cats = 0
var captured_cats = 0
var dead_cats = 0

# to prevent win/fail on start
var is_level_end_check_allowed = false


#Labels
onready var victory_popup = $CanvasLayer/OnVictoryPopup
onready var failure_popup = $CanvasLayer/OnFailPopup

onready var launch_button = $CanvasLayer/GameFlowControls/Start
onready var pause_button = $CanvasLayer/GameFlowControls/Pause
onready var reset_button = $CanvasLayer/GameFlowControls/Restart

onready var cat_free = $CanvasLayer/FlatCatInfo/Free
onready var cat_caught = $CanvasLayer/FlatCatInfo/Caught
onready var cat_dead = $CanvasLayer/FlatCatInfo/Dead

onready var limit_timer_label = $CanvasLayer/TimerVBox/LimitTimerLabel
onready var victory_timer_label = $CanvasLayer/TimerVBox/VictoryTimerLabel

onready var game_time = $CanvasLayer/TimerVBox/GameTime

onready var victory_timer = $VictoryTimer
onready var limit_timer = $LimitTimer


# Called when the node enters the scene tree for the first time.
func _ready():
    MusicController.play_game_music()
    pause_button.disabled = true
    reset_button.disabled = true
    limit_timer_label.visible = false
    victory_timer_label.visible = false
    _on_cat_changed()
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    update_limit_timer_label()
    update_victory_timer_label()
    pass


func on_victory():
    victory_popup.visible = true


func on_failure():
    failure_popup.visible = true


func _on_cat_changed():
    _reset_cat_stats()
    var cats_list = get_tree().get_nodes_in_group("Cat")
    for cat in cats_list:
        if cat.is_captured:
            captured_cats += 1
        elif cat.is_dead:
            dead_cats += 1
        else:
            free_cats += 1

    _update_cat_info()

    if is_level_end_check_allowed:
        check_win_condition()


func _update_cat_info():
    cat_free.text = "Free: %d / %d" % [free_cats, free_cats_to_win]
    cat_caught.text  = "Captured: %d / %d" % [captured_cats, captured_cats_to_win]
    cat_dead.text  = "Dead: %d / %d" % [dead_cats, dead_cats_to_fail]


func _reset_cat_stats():
    free_cats = 0
    captured_cats = 0
    dead_cats = 0


func check_win_condition():
    # equals or less
    if free_cats <= free_cats_to_win\
    and  captured_cats >= captured_cats_to_win\
    and _extra_win_condition():
        
        if victory_timer.is_stopped():
            victory_timer.start()
            victory_timer_label.visible = true
            update_victory_timer_label()
    #        on_victory()
            return
    else:
        victory_timer.stop()
        victory_timer_label.visible = false

    if free_cats >= free_cats_to_fail\
    and dead_cats >= dead_cats_to_fail:
        on_failure()


# To be overriden in other levels, if necessary
func _extra_win_condition():
    return true

func _extra_fail_condition():
    return false


func _on_Start_pressed():
    if is_launched:
        return
        
    if User.current_control != 0:
        return

    var launchable_list = get_tree().get_nodes_in_group("ShouldLaunch")

    for launchable in launchable_list:
        if not launchable.can_launch():
            # add some popup
            # or maybe have some default impulse for all balls
            return
            
    _on_cat_changed()

    game_time.start_time()
    $MinLevelDuration.start()
    $MaxLevelDuration.start()
    limit_timer.start()
    limit_timer_label.visible = true
    update_limit_timer_label()


    var resatable_list = get_tree().get_nodes_in_group("Resetable")

    for resetable in resatable_list:
        if resetable.has_method("save_initial_state"):
            resetable.save_initial_state()
# don't use call group, it doesn't work instantly
# get_tree().call_group("Resetable", "save_initial_state")

    is_launched = true
    for launchable in launchable_list:
        launchable.initial_launch()
        
    launch_button.disabled = true
    reset_button.disabled = false
    pause_button.disabled = false
    User.current_control = 1


func _on_Pause_pressed():
    pass # Replace with function body.


func _on_Restart_pressed():
    print(User.current_control)
    if not (User.current_control == 0 or User.current_control == 1):
        return
    _on_level_restart()


func _on_level_restart():

    limit_timer_label.visible = false
    victory_timer_label.visible = false
    limit_timer.stop()
    victory_timer.stop()

    pause_button.disabled = true
    pause_button.set_pressed(false)
    User.current_control = 0
    is_launched = false
    victory_popup.visible = false
    failure_popup.visible = false
    is_level_end_check_allowed = false

    victory_timer.stop()
    limit_timer.stop()
    $MinLevelDuration.stop()
    $MaxLevelDuration.stop()

#   get_tree().call_group("Deletable", "queue_free")
    var deletable_list = get_tree().get_nodes_in_group("Deletable")

    for deletable in deletable_list:
        deletable.queue_free()

    get_tree().call_group("Resetable", "load_saved_state")
    launch_button.disabled = false

    _on_cat_changed()


func pause_game():
    get_tree().paused = true

func unpause_game():
    get_tree().paused = false


func _on_MinLevelDuration_timeout():
    is_level_end_check_allowed = true


func _on_Pause_toggled(button_pressed):
    pass
#    if button_pressed:
#        pause_game()
#    else:
#        unpause_game()
#    pass # Replace with function body.


func _on_LimitTimer_timeout():
    on_failure()


func _on_VictoryTimer_timeout():
    on_victory()

func update_limit_timer_label():
    if not limit_timer_label.visible:
        return
    limit_timer_label.text = GUtils.format_time(limit_timer.time_left)

func update_victory_timer_label():
    if not victory_timer_label.visible:
        return
    victory_timer_label.text = GUtils.format_time(victory_timer.time_left)


func _on_MainMenu_pressed():
    GSceneManager.goto_scene_wloader("res://main_scenes/main_menu/main_menu.tscn")


func _on_Exit_pressed():
    get_tree().quit()


func _on_NextLevel_pressed():
    GSceneManager.goto_scene_wloader(next_level_path)
