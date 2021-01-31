extends Node2D

# presistent parameters - to be saved-restored-loaded
var initial_rotation
export(bool) var is_alignable = true

var cat_bodies = 0

# Called when the node enters the scene tree for the first time.
func _ready():
    $InZoneParticles.emitting = false
    $VictoryParticles.emitting = false
    $Area2D.visible = false

func get_item_ui_data():
    return $ItemUIData

func save_initial_state():
    pass

func load_state(state):
    pass

func load_saved_state():
    $InZoneParticles.emitting = false
    $VictoryParticles.emitting = false
    $Area2D.visible = false

func _on_InteractionArea_body_entered(body):
    if body.has_method("on_cat_capture_zone_entered"):
        body.on_cat_capture_zone_entered(self)
        cat_bodies += 1
        $InZoneParticles.emitting = true

func _on_InteractionArea_body_exited(body):
    if body.has_method("on_cat_capture_zone_exited"):
        body.on_cat_capture_zone_exited(self)
        cat_bodies -= 1
        if cat_bodies < 1:
            $InZoneParticles.emitting = false

func _on_victory_timer(is_time):
    if is_time:
        $VictoryParticles.emitting = true
        $Area2D.visible = true
    else:
        $VictoryParticles.emitting = false
        $Area2D.visible = false
