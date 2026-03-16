@tool
extends PanelContainer

const INT_FIELD_PATH = preload("res://addons/odyssey_plugin/views/common/int_field.tscn")
const STRING_FIELD_PATH = preload("res://addons/odyssey_plugin/views/common/string_field.tscn")

const ITEM_TYPES_PATH: String = "res://addons/odyssey_plugin/entities/inventory/item_types/"
const ITEM_SAVE_PATH: String = "res://addons/odyssey_plugin/data/items/"

@onready var opt_item_type: OptionButton = $vbx/hbxTypeSelection/optItemType
@onready var vbx_item_basic_attributes: VBoxContainer = $vbx/vbxAttributes/scr/vbxFields/pnlItemBasicAttributes/vbx/vbxAttributes
@onready var lbl_item_type_name: Label = $vbx/vbxAttributes/scr/vbxFields/pnlItemTypesAttributes/vbx/lblTitle
@onready var vbx_item_type_attributes: VBoxContainer = $vbx/vbxAttributes/scr/vbxFields/pnlItemTypesAttributes/vbx/vbxAttributes

var types_data: Dictionary

func _ready() -> void:
	var config_data: Dictionary = ItemMainEditor.get_config()
	
	types_data = config_data['types']
	
	_update_item_types_list()


func _clear_fields() -> void:
	for c in vbx_item_basic_attributes.get_children():
		c.queue_free()
	
	for c in vbx_item_type_attributes.get_children():
		c.queue_free()


func _update_item_types_list() -> void:
	opt_item_type.clear()
	
	opt_item_type.add_item("Select...")
	
	for type in get_item_types():
		opt_item_type.add_item(str(type).capitalize())
	
	_clear_fields()


func get_item_types() -> Array:
	if not(DirAccess.dir_exists_absolute(ITEM_TYPES_PATH)):
		return []
	
	var list_raw_types: PackedStringArray = DirAccess.get_files_at(ITEM_TYPES_PATH)
	var list_types: Array[String] = []
	
	for item in list_raw_types:
		var formated_item: String = item.split(".")[0]
		
		if not list_types.has(formated_item):
			list_types.append(formated_item)
	
	return list_types


func _on_opt_item_type_item_selected(index: int) -> void:
	_clear_fields()
	
	if index <= 0:
		lbl_item_type_name.text = "Item Type Attributes"
		return
	
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
	
	
	#if index == 0:
		#return
	#
	#_clear_fields()
	#
	#var list_types: Array = types_data.keys()
	#
	#var type_selected: String = list_types[index-1]
	#
	#var type_attributes: Dictionary = types_data[type_selected]
	#
	#print(str(type_attributes))
	#
	#for attribute in type_attributes.keys():
		#print(str(attribute))
		##print(str(type_attributes[attribute]['type']))
		#
		#if attribute == "sub_types":
			#pass
		#elif type_attributes[attribute]["type"] == "STRING":
			#var new_string_field: StringField = STRING_FIELD_PATH.instantiate()
			#vbx_fields.add_child(new_string_field)
			#
			#new_string_field.lbl_title.text = str(attribute).capitalize()
			#
		#elif type_attributes[attribute]["type"] == "INT":
			#var new_int_field: IntField = INT_FIELD_PATH.instantiate()
			#vbx_fields.add_child(new_int_field)
			#
			#if type_attributes[attribute]["min_value"]:
				#new_int_field.txt_value.min_value = float(type_attributes[attribute]["min_value"])
			#
			#if type_attributes[attribute]["max_value"]:
				#new_int_field.txt_value.max_value = float(type_attributes[attribute]["max_value"])
			#
			#new_int_field.lbl_title.text = str(attribute).capitalize()
			
			
			
	


func _on_btn_reload_pressed() -> void:
	_update_item_types_list()


func _on_btn_save_pressed() -> void:
	pass # Replace with function body.
