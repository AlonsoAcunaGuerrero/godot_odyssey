@tool
class_name IntField
extends FormField

@onready var lbl_title: Label = $hbx/lblTitle
@onready var txt_value: SpinBox = $hbx/hbxValue/txtValue

func get_value() -> Variant:
	return txt_value.value
