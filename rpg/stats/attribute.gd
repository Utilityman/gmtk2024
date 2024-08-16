@icon("res://assets/icons/net/game-icons/broken-heart.16x16.svg")
class_name Attribute extends Statistic

signal on_current_changed

@export var current: float = 0.0:
    set(next):
        current = clamp(next, 0, value)
        on_current_changed.emit(current)
