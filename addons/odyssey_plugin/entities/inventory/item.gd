class_name ItemResource
extends Resource

const MAX_STACK_VALUE: int = 999

@export var icon: Texture2D
@export var item_name: String
@export_multiline() var description: String
@export_range(1, MAX_STACK_VALUE) var max_stack: int
