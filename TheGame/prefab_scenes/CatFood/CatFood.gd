extends RigidBody2D

var is_active_mode = false
export(bool) var is_alignable = true

var cat_spawner = null
# Called when the node enters the scene tree for the first time.
func _ready():
    pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    disable_all_forcefield_passes()
    pass


func go_to_sleep_mode():
    sleeping = true

func go_to_actibe_mode():
    sleeping = false

func on_activation_zone_activated(activation_zone):
    pass

func on_cat_striked(new_cat_spawner):

    if cat_spawner:
        return
    cat_spawner = new_cat_spawner
    $Timer.start()

func _on_Timer_timeout():
    
    var cat_position = get_global_position()
    var cat_impulse = get_linear_velocity() * mass
    var cat_rotation = rotation
    var cat_ang_vel = angular_velocity
    cat_spawner.spawn_additional_cat(cat_position, cat_impulse, cat_rotation, cat_ang_vel)
    queue_free()
    
func disable_all_forcefield_passes():
    var layers_list = Forcefields.get_all_forcefield_layers()
    
    for layer in layers_list:
        set_collision_mask_bit(layer, true)
