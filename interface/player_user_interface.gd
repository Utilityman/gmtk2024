class_name PlayerUserInterface extends Control

@export var config: PlayerUIConfig

@onready var player_aura_bar: AuraBar = $PlayerAuraBar
@onready var player_frame: EntityFrame = $%PlayerFrame
@onready var target_frame: EntityFrame = $%TargetFrame
@onready var target_aura_bar: AuraBar = $TargetFrame/TargetAuraBar
@onready var action_bar: ActionBar = $%ActionBar
@onready var spellbook_window: SpellbookWindow = $%SpellbookWindow

@onready var spellbook_button: Button = $%TmpSpellbookButton

var entity: Entity:
	set(new_entity):
		entity = new_entity
		player_aura_bar.entity = entity
		player_frame.entity = entity
		action_bar.entity = entity
		spellbook_window.entity = entity

		_on_entity_target_changed(entity.target)
		entity.on_target_changed.connect(_on_entity_target_changed)


func _ready() -> void:
	spellbook_button.pressed.connect(_on_spellbook_button_pressed)

func _on_spellbook_button_pressed () -> void:
	spellbook_window.visible = !spellbook_window.visible

func _on_entity_target_changed (new_target: Entity) -> void:
	if new_target:
		target_frame.entity = new_target
		target_aura_bar.entity = new_target
		target_frame.visible = true
		target_aura_bar.visible = true
	else:
		target_frame.visible = false
		target_aura_bar.visible = false
		# TODO: this should probably unset the entity on each of these things too?
		# TODO: target_frame.entity = null - does this work? - does this need to work?

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("SPELLBOOK_TOGGLE"):
		entity.spellbook.log()
