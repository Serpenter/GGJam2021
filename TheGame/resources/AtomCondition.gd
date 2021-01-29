extends Resource

export(int) var less_or_equal_than = 0
export(int) var more_or_equal_than = 0
export(float) var after = 0.0
export(float) var before = INF
export(String) var object_group = ""


func _init():
    self.resource_local_to_scene = true
# Called when the node enters the scene tree for the first time.
#func _init(p_health = 0, p_sub_resource = null, p_strings = []):
#    health = p_health
#    sub_resource = p_sub_resource
#    strings = p_strings
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
