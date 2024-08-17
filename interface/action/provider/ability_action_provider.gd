class_name AbilityActionProvider extends _ActionProvider
# TODO: what if this was a node that also lived on the action button?

# TODO: can this just watch the cooldown component for the ability that we care about?
#       - this doesn't currently work with cooldowns that get reduced

# TODO: this needs to be null safe on the ability

@export var ability: Ability
var entity_local: Entity

func setup (entity: Entity) -> void:
	entity_local = entity
	if not entity_local.is_node_ready(): await entity_local.ready
	entity_local.cooldowns.global_cooldown_set.connect(_on_gcd_set)
	entity_local.cooldowns.ability_cooldown_set.connect(_on_ability_cooldown)
	entity_local.cooldowns.cooldown_reduced.connect(_on_cooldown_reduced)

func get_icon () -> Texture2D:
	return ability.icon

func activate () -> void:
	# TODO: fixme null pointer on entity_local.target not existing
	entity_local.use_ability_by_id.rpc_id(1, ability.id, entity_local.target.name)

func has_tooltip () -> bool:
	return true

# TODO: I think it'd be much better if the ability could provide a tooltip instead of these
# - thinking of cost, cooldown, etc.
func get_tooltip_title () -> String:
	return ability.name

func get_tooltip_description () -> String:
	return ability.description

func _on_gcd_set (duration: float) -> void:
	if ability.off_global_cooldown: return
	on_timer_set.emit(duration)

func _on_ability_cooldown (triggered_ability: EntityCooldown) -> void:
	if ability.id == triggered_ability.id:
		on_timer_set.emit(triggered_ability.duration)

func _on_cooldown_reduced (cooldown: EntityCooldown) -> void:
	if ability.id == cooldown.id:
		on_timer_update.emit(cooldown.duration)
