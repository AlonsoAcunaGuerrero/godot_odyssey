@tool
extends PanelContainer

const INT_FIELD_PATH = preload("res://addons/odyssey_plugin/views/common/int_field.tscn")
const STRING_FIELD_PATH = preload("res://addons/odyssey_plugin/views/common/string_field.tscn")
const IMAGE_FIELD_PATH = preload("res://addons/odyssey_plugin/views/common/image_field.tscn")

const ITEM_TYPES_PATH: String = "res://addons/odyssey_plugin/entities/items/types/"
const ITEM_SAVE_PATH: String = "res://addons/odyssey_plugin/data/items/"

@onready var opt_item_type: OptionButton = $vbx/hbxTypeSelection/optItemType
@onready var vbx_item_basic_attributes: VBoxContainer = $vbx/vbxAttributes/scr/vbxFields/pnlItemBasicAttributes/vbx/vbxAttributes
@onready var lbl_item_type_name: Label = $vbx/vbxAttributes/scr/vbxFields/pnlItemTypesAttributes/vbx/lblTitle
@onready var vbx_item_type_attributes: VBoxContainer = $vbx/vbxAttributes/scr/vbxFields/pnlItemTypesAttributes/vbx/vbxAttributes


var types_path_list: PackedStringArray


func _ready() -> void:
	types_path_list = []
	
	_update_item_types_list()


func _clear_fields() -> void:
	for c in vbx_item_basic_attributes.get_children():
		c.queue_free()
	
	for c in vbx_item_type_attributes.get_children():
		c.queue_free()


func _update_item_types_list() -> void:
	lbl_item_type_name.text = "Item Type Attributes"
	
	types_path_list = []
	types_path_list = get_item_types()
	
	opt_item_type.clear()
	
	opt_item_type.add_item("Select...")
	
	for type in types_path_list:
		var type_file_name: String = type.split("/")[-1]
		var type_name: String = type_file_name.split(".")[0]
		
		opt_item_type.add_item(str(type_name).capitalize())
	
	_clear_fields()


func get_item_types() -> PackedStringArray:
	if not(DirAccess.dir_exists_absolute(ITEM_TYPES_PATH)):
		return []
	
	var list_raw_types: PackedStringArray = DirAccess.get_files_at(ITEM_TYPES_PATH)
	var list_types: PackedStringArray = []
	
	for item in list_raw_types:
		if item.split(".")[-1] != "gd":
			continue
		
		var type_path: String = ITEM_TYPES_PATH + "/" + str(item)
		var type_script = load(type_path)
		
		if type_script.new() is ItemResource:
			list_types.append(type_path)
	
	return list_types


func _on_opt_item_type_item_selected(index: int) -> void:
	_clear_fields()
	
	if index <= 0:
		lbl_item_type_name.text = "Item Type Attributes"
		return
	
	print(types_path_list[index-1])
	
	var item_type_name: String = opt_item_type.get_item_text(index)
	item_type_name = item_type_name.to_lower()
	item_type_name = item_type_name.replace(" ", "_")
	
	var script_path: String = ITEM_TYPES_PATH + "/" + item_type_name + ".gd"
	
	var item_type_instance = load(script_path).new()
	
	var properties_list: Array[Dictionary] = item_type_instance.get_property_list()
	
	var item_properties_list: Array[Dictionary] = ItemResource.new().get_property_list().filter(
		func(prop):
			var usage = prop["usage"]
			return usage & PROPERTY_USAGE_SCRIPT_VARIABLE
	)
	
	_draw_item_fields(vbx_item_basic_attributes, item_properties_list)
	
	var item_type_properties_list: Array[Dictionary] = properties_list.filter(
		func(prop):
			var usage = prop["usage"]
			return (usage & PROPERTY_USAGE_SCRIPT_VARIABLE) and not(item_properties_list.has(prop))
	)
	
	lbl_item_type_name.text = item_type_name.capitalize() + " Attributes"
	_draw_item_fields(vbx_item_type_attributes, item_type_properties_list)

func _draw_item_fields(vbx_fields: Control, properties_list: Array[Dictionary]) -> void:
	for prop in properties_list:
		if prop["type"] == TYPE_INT:
			var new_int_field: IntField = INT_FIELD_PATH.instantiate()
			vbx_fields.add_child(new_int_field)
			
			var range: PackedStringArray = str(prop["hint_string"]).split(",") 
			
			var min_value: int = int(range[0])
			var max_value: int = int(range[1])
			
			if min_value:
				new_int_field.txt_value.min_value = float(min_value)
			
			if max_value:
				new_int_field.txt_value.max_value = float(max_value)
			
			new_int_field.lbl_title.text = str(prop["name"]).capitalize()
		elif prop["type"] == TYPE_STRING:
			var new_string_field: StringField = STRING_FIELD_PATH.instantiate()
			vbx_fields.add_child(new_string_field)
			
			new_string_field.lbl_title.text = str(prop["name"]).capitalize()
		elif prop["type"] == TYPE_OBJECT:
			if prop["class_name"] == "Texture2D":
				var new_image_field: ImageField = IMAGE_FIELD_PATH.instantiate()
				vbx_fields.add_child(new_image_field)
				
				new_image_field.lbl_title.text = str(prop["name"]).capitalize()
	


func generate_v4() -> String:
	var b = []
	for i in range(16):
		b.append(randi() % 256)
	
	b[6] = (b[6] & 0x0f) | 0x40
	b[8] = (b[8] & 0x3f) | 0x80
	
	return "%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-%02x%02x%02x%02x%02x%02x" % [
		b[0], b[1], b[2], b[3],
		b[4], b[5],
		b[6], b[7],
		b[8], b[9],
		b[10], b[11], b[12], b[13], b[14], b[15]
	]


func _on_btn_reload_pressed() -> void:
	_update_item_types_list()


func _on_btn_save_pressed() -> void:
	pass # Replace with function body.
