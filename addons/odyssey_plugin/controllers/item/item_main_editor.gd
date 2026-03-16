@tool
class_name ItemMainEditor
extends PanelContainer

@onready var create_item_panel: PanelContainer = $vbx/vbxContent/pnlContent/CreateNewItem
@onready var btn_create: Button = $vbx/vbxContent/hbx/btnCreate

func _ready() -> void:
	pass


static func get_config() -> Dictionary:
	const ITEM_CONFIG_PATH = "res://addons/odyssey_plugin/config/item_config.json"
	
	#VERIFYING IF THE CONFIG FILE EXIST
	if not(FileAccess.file_exists(ITEM_CONFIG_PATH)):
		return {}
	
	#TRYING TO OPEN THE CONFIG FILE
	var file_config: FileAccess = FileAccess.open(ITEM_CONFIG_PATH, FileAccess.READ)
	if file_config == null:
		return {}
	
	var file_content: String = file_config.get_as_text()
	
	return JSON.parse_string(file_content) as Dictionary


func _on_btn_create_toggled(toggled_on: bool) -> void:
	create_item_panel.visible = toggled_on
	
	#var new_item: WeaponResource = WeaponResource.new()
	#for prop in new_item.get_property_list():
		#var usage = prop["usage"]
		#
		#if usage & PROPERTY_USAGE_SCRIPT_VARIABLE:
			#print(prop)


func _on_btn_list_toggled(toggled_on: bool) -> void:
	pass
	#var new_item: ItemResource = ItemResource.new()
	#print(PropertyUsageFlags.PROPERTY_USAGE_SCRIPT_VARIABLE)
	#var new_item: ItemResource = ItemResource.new()
	#for prop in new_item.get_property_list():
		#var usage = prop["usage"]
		#
		#if usage & PROPERTY_USAGE_SCRIPT_VARIABLE:
			#print(prop)
