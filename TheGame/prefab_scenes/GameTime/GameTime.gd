extends Label


var time = 0


func _on_LevelTime_timeout():
    time += 1
    text = GUtils.format_time(time)


func reset_time():
    $LevelTime.stop()
    time = 0
    text = GUtils.format_time(time)


func start_time():
    $LevelTime.start()


func stop_time():
    $LevelTime.stop()
