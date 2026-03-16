@tool
extends EditorPlugin

const MAIN_PANEL = preload("res://addons/odyssey_plugin/views/main_panel.tscn")
var main_panel_instance

func _enter_tree() -> void:
	main_panel_instance = MAIN_PANEL.instantiate()
	EditorInterface.get_editor_main_screen().add_child(main_panel_instance)
	_make_visible(false)


func _exit_tree() -> void:
	if main_panel_instance:
		main_panel_instance.queue_free()


func _has_main_screen() -> bool:
	return true


func _make_visible(visible):
	if main_panel_instance:
		main_panel_instance.visible = visible


func _get_plugin_name():
	return "Odyssey"


func _get_plugin_icon():
	return EditorInterface.get_editor_theme().get_icon("Node", "EditorIcons")


func _enable_plugin() -> void:
	add_autoload_singleton("DialogueInterface", "res://addons/odyssey_plugin/ui/dialogue/dialogue_interface.tscn")


func _disable_plugin() -> void:
	remove_autoload_singleton("DialogueInterface")
