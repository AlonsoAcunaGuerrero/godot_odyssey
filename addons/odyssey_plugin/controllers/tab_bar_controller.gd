@tool
class_name TabBarController
extends PanelContainer

@onready var btn_items: Button = $vbx/btnItems
@onready var btn_characters: Button = $vbx/btnCharacters
@onready var btn_dialogues: Button = $vbx/btnDialogues

@export var items_panel: PanelContainer
@export var characters_panel: PanelContainer
@export var dialogues_panel: PanelContainer

func _ready() -> void:
	btn_items.button_pressed = true
	btn_characters.button_pressed = false
	btn_dialogues.button_pressed = false

func _on_btn_items_toggled(toggled_on: bool) -> void:
	if not(items_panel):
		return
	
	items_panel.visible = toggled_on


func _on_btn_characters_toggled(toggled_on: bool) -> void:
	if not(characters_panel):
		return
	
	characters_panel.visible = toggled_on


func _on_btn_dialogues_toggled(toggled_on: bool) -> void:
	if not(dialogues_panel):
		return
	
	dialogues_panel.visible = toggled_on
