@icon("res://assets/icons/net/game-icons/backward-time.32x32.svg")
class_name CooldownComponent extends Node

var cooldown_scene: PackedScene = preload("res://entity/components/entity_cooldown.tscn")

signal global_cooldown_set
signal ability_cooldown_set
signal cooldown_reduced

var ability_cooldowns: Dictionary = {}
# TODO: what if global cooldown was another AbilityCooldown component?
@export var global_cooldown: float = 0.0:
	set(value):
		if (value > global_cooldown): global_cooldown_set.emit(value)
		global_cooldown = max(value, 0)
		

@onready var cooldown_spawner: MultiplayerSpawner = $CooldownSpawner

func _ready() -> void:
	cooldown_spawner.spawned.connect(_on_cooldown_spawn)
	cooldown_spawner.despawned.connect(_on_cooldown_despawn)

func _on_cooldown_spawn (cooldown: EntityCooldown) -> void:
	if ability_cooldowns.has(cooldown.id): _on_cooldown_expired(cooldown.id)
	ability_cooldowns[cooldown.id] = cooldown
	cooldown.expired.connect(_on_cooldown_expired)
	ability_cooldown_set.emit(cooldown)

func _on_cooldown_despawn (cooldown: EntityCooldown) -> void:
	_on_cooldown_expired(cooldown.id)

func set_global_cooldown (duration: float) -> void:
	global_cooldown = duration

func set_cooldown (ability: Ability) -> void:
	EntityCooldown.new()
	var cooldown: EntityCooldown = cooldown_scene.instantiate()
	cooldown.setup(ability)

	add_child(cooldown)
	_on_cooldown_spawn(cooldown)

func reduce_cooldown (ability: Ability, duration: float) -> void:
	var remaining: float = ability_cooldowns[ability.id]
	ability_cooldowns[ability.id] = max(0, remaining - duration)
	cooldown_reduced.emit(ability, ability_cooldowns[ability.id])

func reduce_cooldown_by_id(id: String, duration: float) -> void:
	if ability_cooldowns.has(id):
		var cooldown: EntityCooldown = ability_cooldowns[id]
		cooldown.duration -= duration
		cooldown_reduced.emit(cooldown)

func _on_cooldown_expired (id: String) -> void:
	Logger.info("Cooldown expired:" + id)
	if ability_cooldowns.has(id):
		var cooldown: EntityCooldown = ability_cooldowns[id]
		cooldown.queue_free()
		ability_cooldowns.erase(cooldown.id)

func _process(delta: float) -> void:
	if global_cooldown > 0.0: global_cooldown -= delta
