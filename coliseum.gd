class_name Coliseum extends Node3D

@export var player_cuttoff: int = 1
@export var arena_time: int = 45

@onready var player: Entity = $Player
@onready var timer: Timer = $Timer

@onready var goal_label: Label = $Control/GoalContainer/GoalLabel
@onready var player_label: Label = $Control/PlayerCountContainer/PlayerCountLabel
@onready var timer_label: Label = $Control/Timer

var players_remaining: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start(arena_time)
	timer.timeout.connect(_on_timer_timeout)
	players_remaining = get_tree().get_node_count_in_group("ENTITY")
	for node: Node in get_tree().get_nodes_in_group("ENTITY"):
		if node is not Entity: 
			Logger.warn("Found non-player with ENTITY group tag: " + str(node))
			players_remaining -= 1
			continue
		var entity: Entity = node as Entity
		entity.death.connect(_on_entity_death)

	goal_label.text = "Survive to be in top " + str(player_cuttoff) + "!"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer_label.text = "%d:%02d" % [floor($Timer.time_left / 60), int($Timer.time_left) % 60]
	if timer.time_left < 30.0:
		timer_label.text = "%10.1f" % timer.time_left
	player_label.text = "Players Remaining\n  " + str(players_remaining)



func _on_timer_timeout () -> void:
	print("OUT OF TIME!")

func _on_entity_death () -> void:
	players_remaining -= 1
	if players_remaining <= player_cuttoff:
		print("END THE GAME!!!")
		
