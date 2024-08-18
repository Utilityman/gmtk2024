class_name PlayerData extends Resource

@export var data: RpgData
@export var punch_ability: Ability
@export var shoot_ability: Ability
@export var money: int = 100
@export var arms: int = 0 #0-4 levels
@export var head: int = 0 #0-4 levels
# is this where we'll collect the nuts/bolts resources?


func get_arms_scale () -> float:
    # TMP TODO
    if arms == 1 and head == 0: return 3.0
    if arms == 1 and head == 1: return 1 / 3.0
    return 1.0

func get_player_capsule_height () -> float:
    return 2.0