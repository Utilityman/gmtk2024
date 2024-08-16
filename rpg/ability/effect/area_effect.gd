class_name AreaEffect extends _AbilityEffect

var area_effect_scene: PackedScene = preload("res://game/effects/area_effect_3d.tscn")

@export var data: AreaEffectData
@export var effects : Array[_AbilityEffect] = []

var _context: EffectContext

func apply (context: EffectContext) -> void:
	_context = context
	var target: Entity = context.target

	var area_effect_3d: Area3D = area_effect_scene.instantiate()
	area_effect_3d.body_entered.connect(on_hit)

	# TODO: a way to spawn the effect on target or SELF - whirlwind, immolation aura, etc.
	target.projectile_source.add_child(area_effect_3d)
	area_effect_3d.collision_shape.shape = data.shape
	# TODO: the collision shape should be rotated to the same angle as the player basis? or the target's?

func on_hit (body: Node3D) -> void:
	if not body is Entity: return

	var entity: Entity = body
	if entity == _context.source and not data.hit_self: return

	var area_effect_context: EffectContext = EffectContext.new(_context.source, entity)
	area_effect_context.source_ability = _context.source_ability
	area_effect_context.source_aura = _context.source_aura

	for effect: _AbilityEffect in effects: 
		effect.apply(area_effect_context)


