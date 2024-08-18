class_name PlayerData extends Resource

@export var data: RpgData
@export var punch_ability: Ability
@export var shoot_ability: Ability
@export var money: int
@export var arms: int = 0 #0-4 levels
@export var head: int = 0 #0-4 levels
# is this where we'll collect the nuts/bolts resources?


func get_arms_scale () -> float:
    if head == 0:
        return 1
    if head == 1:
        return 0.3333
    if head == 2:
        return 0.5999
    if head == 3:
        return 0.6944
    return 0.0

func get_player_capsule_height () -> float:
    return 2.0