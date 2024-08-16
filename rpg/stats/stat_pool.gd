class_name StatPool extends Resource

var max_value: int:
    set(value):
        max_value = value

var current_value: float:
    set (value):
        current_value = min(value, max_value)