@tool
class_name ImageField
extends FormField

@onready var lbl_title: Label = $vbx/lblTitle
@onready var img_ref: TextureRect = $vbx/hbx/imgRef
@onready var file_dialog: FileDialog = $FileDialog

func get_value() -> Variant:
	return null


func _on_btn_open_image_pressed() -> void:
	file_dialog.visible = true


func _on_file_dialog_file_selected(path: String) -> void:
	img_ref.texture = ResourceLoader.load(path)
