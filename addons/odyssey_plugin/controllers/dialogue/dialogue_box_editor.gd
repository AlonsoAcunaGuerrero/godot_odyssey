@tool
extends PanelContainer

var dialogue: DialogueRes = null

@onready var txt_name: TextEdit = $vbx/pnlName/vbx/hbxFinalName/txtName
@onready var lbl_final_name: Label = $vbx/pnlName/vbx/hbxFinalName/lblFinalName

@onready var txt_dialogue: TextEdit = $vbx/hbxDialogue/vbxEdit/pnlDialogueEdit/txtDialogue
@onready var lbl_final_dialogue: RichTextLabel = $vbx/hbxDialogue/vbxResult/lblFinalDialogue

func _ready() -> void:
	if dialogue:
		pass
	else:
		txt_name.visible = true
	
	txt_dialogue.connect("text_changed", _update_final_dialogue)

func _update_final_dialogue():
	lbl_final_dialogue.text = txt_dialogue.text
