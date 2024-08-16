extends Node3D


@onready var player: Entity = $Player
@onready var ui: PlayerUserInterface = $Player/PlayerUI

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.ui = ui


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
