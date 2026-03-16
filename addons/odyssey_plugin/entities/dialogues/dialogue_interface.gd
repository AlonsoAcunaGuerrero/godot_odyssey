extends CanvasLayer

signal player_start_interaction()
signal player_end_interaction()

var can_interact: bool = true
var can_move: bool = true

var dialogue_pos: int = 0
var dialogue_list: DialogueListRes = null

@onready var root: Control = $Root

func set_dialogue_list(path: String) -> DialogueListRes:
	if FileAccess.file_exists(path):
		var res: Resource = ResourceLoader.load(path)
		
		if res is DialogueListRes:
			dialogue_list = ResourceLoader.load(path) as DialogueListRes
			return dialogue_list
		else:
			return null
	else:
		return null

func start_dialoguing(id: String) -> void:
	if can_interact:
		can_move = false
		can_interact = false
		
		const DIALOGUE_PATH: String = "res://addons/odyssey_plugin/data/dialogues/"
		
		set_dialogue_list(DIALOGUE_PATH + id + ".tres")
		
		var dialogue: DialogueRes = dialogue_list.dialogue_list[dialogue_pos]
		
		emit_signal("player_start_interaction")


func finish_interaction():
	emit_signal("player_end_interaction")
	can_move = true
	await get_tree().create_timer(0.5, false).timeout
	can_interact = true
