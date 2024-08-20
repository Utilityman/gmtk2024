class_name PauseMenu extends Control

@export var quit_to_scene: PackedScene
@export var disabled: bool = false

@onready var overlay: TextureRect = $MenuScreenOverlay
@onready var menu: VBoxContainer = $Menu

@onready var resume: Button = $%Resume
@onready var quit: Button = $%Quit

var starting_mouse_mode: Input.MouseMode

func _ready() -> void:
	self.visible = false
	resume.pressed.connect(unpause)
	quit.pressed.connect(quit_to)

func _process(_delta: float) -> void:
	if not disabled and Input.is_action_just_pressed("PAUSE"):
		if not get_tree().paused:
			starting_mouse_mode = Input.mouse_mode
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			visible = true
		else:
			visible = false
			Input.mouse_mode = starting_mouse_mode
		get_tree().paused = !get_tree().paused

func unpause () -> void:
	visible = false
	Input.mouse_mode = starting_mouse_mode
	get_tree().paused = false

func quit_to () -> void:
	get_tree().paused = false
	SceneTransition.call_deferred("change_scene_to_file", "res://main_menu.tscn")		
