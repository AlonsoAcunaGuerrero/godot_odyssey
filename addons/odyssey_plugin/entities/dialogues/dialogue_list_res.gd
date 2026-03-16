class_name DialogueListRes
extends Resource

@export var dialogue_list: Array[DialogueRes]

#func get_next_dialogue() -> DialogueRes:
	#if dialogue_list.size() > 0:
		#return dialogue_list.pop_front()
	#else:
		#return null 
