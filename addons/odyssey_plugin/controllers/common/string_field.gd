@tool
class_name StringField
extends FormField

@onready var lbl_title: Label = $hbx/lblTitle
@onready var txt_value: TextEdit = $hbx/txtValue

func get_value() -> Variant:
	return txt_value.text
