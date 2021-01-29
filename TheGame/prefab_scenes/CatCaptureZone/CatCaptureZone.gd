extends Node2D

# presistent parameters - to be saved-restored-loaded
var initial_rotation
export(bool) var is_alignable = true

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

func get_item_ui_data():
    return $ItemUIData



func _on_InteractionArea_body_entered(body):
    if body.has_method("on_cat_capture_zone_entered"):
        body.on_cat_capture_zone_entered(self)


func _on_InteractionArea_body_exited(body):
    if body.has_method("on_cat_capture_zone_exited"):
        body.on_cat_capture_zone_exited(self)
