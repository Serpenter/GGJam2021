extends RigidBody2D

var is_active_mode = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func go_to_sleep_mode():
	sleeping = true

func go_to_actibe_mode():
	sleeping = false

func on_activation_zone_activated(activation_zone):
	pass
