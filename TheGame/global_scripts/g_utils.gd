extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
func get_resized_texture(t: Texture, width: int = 0, height: int = 0):
    var image = t.get_data()
    if width > 0 && height > 0:
        image.resize(width, height)
        var itex = ImageTexture.new()
        itex.create_from_image(image)
        return itex
        
        
enum TimeFormat {
    FORMAT_HOURS   = 1 << 0,
    FORMAT_MINUTES = 1 << 1,
    FORMAT_SECONDS = 1 << 2
}


func format_time(time, format = TimeFormat.FORMAT_MINUTES | TimeFormat.FORMAT_SECONDS, digit_format = "%02d"):
    var digits = []

    if format & TimeFormat.FORMAT_HOURS:
        var hours = digit_format % [time / 3600]
        digits.append(hours)

    if format & TimeFormat.FORMAT_MINUTES:
        var minutes = digit_format % [time / 60]
        digits.append(minutes)

    if format & TimeFormat.FORMAT_SECONDS:
        var seconds = digit_format % [int(ceil(time)) % 60]
        digits.append(seconds)

    var formatted = String()
    var colon = " : "

    for digit in digits:
        formatted += digit + colon

    if not formatted.empty():
        formatted = formatted.rstrip(colon)

    return formatted
