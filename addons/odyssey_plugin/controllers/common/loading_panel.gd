@tool
extends PanelContainer

@onready var img_circle: TextureRect = $CenterContainer/vbx/imgCircle

func _ready() -> void:
	img_circle.pivot_offset = Vector2(
		img_circle.size.x / 2,
		img_circle.size.y / 2
	)

func _process(delta: float) -> void:
	img_circle.rotation_degrees -= 100.0 * delta
