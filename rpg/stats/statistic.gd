@icon("res://assets/icons/net/game-icons/hearts.16x16.svg")
class_name Statistic extends Node

signal on_value_changed

@export var id: String
@export var value: float = 0.0:
    set(new_value):
        value = new_value
        on_value_changed.emit(value)