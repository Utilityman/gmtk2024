class_name ActionTooltip extends PanelContainer

@onready var title: Label = $VBoxContainer/Title
@onready var description: Label = $VBoxContainer/Description

func set_title (title_text: String) -> void:
	title.text = title_text

func set_description (description_text: String) -> void:
	description.text = description_text
