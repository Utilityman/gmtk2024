class_name ProjectileEffect extends _AbilityEffect

var projectile_scene: PackedScene = preload("res://game/effects/projectile_3d.tscn")

# TODO: I'm thinking a fun behavior could be projectiles/effects
#		that occur in the game world either on_expiration OR on contact with something
# 		resulting in some sort of an AoE or something.

@export var data: ProjectileData
@export var effects: Array[_AbilityEffect] = []

var _context: EffectContext

func apply (context: EffectContext) -> void:
	_context = context
	var source: Entity = context.source
	var target: Entity = context.target

	var projectile: Projectile3D = projectile_scene.instantiate()
	projectile.source = source
	projectile.target = target
	projectile.add_projectile_data(data)
	projectile.enabled = true

	
	source.projectile_source.add_child(projectile, true)
	projectile.global_position = source.projectile_source.global_position

	projectile.on_entity_hit.connect(_projectile_on_entity_hit)

func _projectile_on_entity_hit (entity: Entity) -> void:
	_context.target = entity
	for effect: _AbilityEffect in effects: 
		effect.apply(_context)
