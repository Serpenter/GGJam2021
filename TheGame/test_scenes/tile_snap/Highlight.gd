extends Control


export(Color, RGBA) var highlight_color

var tile_size = Vector2()
var tile_offset = Vector2()
var tiles = []

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass

func _draw():
    for tile in tiles:
        draw_rect(Rect2(tile + tile_offset, tile_size), highlight_color, false, 3.0)
