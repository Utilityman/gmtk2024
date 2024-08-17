class_name Entity extends CharacterBody3D

# TODO: how will it work injecting a model with animations (and physics?) onto this? 
# 		I'm thinking that if I wanted to add an entity with a model that's not this person, I'm not sure how I can/would do that
signal death
signal shoot
signal punch
signal on_target_changed

@export var shoot_ability: Ability 
@export var melee: Ability 

# @deprecated - I don't want to use this resource for anything besides loading the character in. 
# 				since we can't replicate this easily, we MUST use nodes with replicated properties instead.
# 				when saving, an RpgData will be created from the attributes of the nodes
@export_category("RPG Definition")
@export var data: RpgData

@export_category("Camera and Interface")
# TODO: the UI should not be a child of player but instead provided in the same manner here 
@export var camera: ObservingCamera:
	set(value):
		camera = value
		if not camera: return
		camera.on_entity_raycast.connect(_handle_raycast)
@export var ui: PlayerUserInterface:
	set(value):
		ui = value
		if not ui: return
		ui.entity = self

@export_category("Character Atributes")
@export var speed: float = 5.0
@export var number_of_jumps: int = 1
@export var jump_velocity: float = 4.5 # TODO: change this to a jump height 
@export var gravity: float = 9.8
@export var rotation_speed: float = 6.0

# TODO: I don't like this - eventually I'd hope we can have a "NodeAdapter"(?) or something
# 		that can be used to query various critical points from an entity's model 
# 		Center, Top, Bottom, ProjectileSource, etc.
@onready var projectile_source: Node3D = $ProjectileSource
@onready var health_bar: ProgressBar3D = $HealthBar3D

# PRIVATE
@onready var _jump_counter: int = number_of_jumps
@onready var model: RobotModel = $RobotModel

# TODO: anything that is in RPGData that needs to be shared with clients should be put into a node which can replicate those infos
# Something like the name and such needs to be replicated
@onready var info: EntityInfo = $Info
@onready var stats_component: StatsComponent = $Stats
@onready var aura_component: AuraComponent = $Auras
@onready var cooldowns: CooldownComponent = $Cooldowns
@onready var spellbook: SpellbookComponent = $Spellbook
@onready var inventory: InventoryComponent = $Inventory
# TODO: all entities can have equipment as well

# TODO: this will somehow want to be replicated (replicate by id which then could be looked up?)
var target: Entity:
	set(new_target):
		target = new_target
		on_target_changed.emit(target)
var is_alive: bool = true

func _ready() -> void:
	# if the data exists, then setup the character components
	if data:
		load_rpg_data()
		if data is HeroData:
			load_hero_data()
	stats_component.health.on_current_changed.connect(_on_health_changed)

func load_rpg_data () -> void:
	info.load_data(data)
	stats_component.add_stat_block(data.base_stats)

	# TODO: I don't necessarily like this
	for ability: Ability in data.spellbook.abilities:
		for passive: BaseAura in ability.passives:
			var dupe: BaseAura = passive.duplicate()
			dupe.source = self
			aura_component.add_aura(dupe)
	stats_component.health.current = stats_component.health.value
	spellbook.load_data(data.spellbook)

func load_hero_data () -> void:
	inventory.load(data as HeroData)

func _input(_event: InputEvent) -> void:
	# right click to rotate the player + emit an event (which should denote to the camera to look "forward")
	pass

func _handle_raycast (entity: Entity) -> void:
	print_stats(entity)
	target = entity

func print_stats (entity: Entity) -> void:
	print("Entity: ", entity)
	printt("Health", entity.stats_component.health.current, " / ", entity.stats_component.health.value )
	printt("Strength", entity.stats_component.strength.value)
	for resource: ResourceType.Type in entity.stats_component.resources.keys():
		printt(ResourceType.as_string(resource), entity.stats_component.resources[resource].current_value, '/', entity.stats_component.resources[resource].max_value)

func should_jump () -> bool:
	return false

func get_direction () -> Vector3:
	return Vector3.ZERO

func get_rotate_direction () -> float:
	return 0.0

func _process(delta: float) -> void:
	health_bar.value = stats_component.health.current / stats_component.health.value

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta

	# TODO: if you fall off something, you can still jump here (only double+ jump should allow for a midair jump)
	if should_jump() and _jump_counter > 0:
		velocity.y = jump_velocity
		_jump_counter -= 1

	var direction: Vector3 = get_direction()

	# Rotates the _camera_pivot_y only when theres Directional Input, allowing the NetworkedPlayer to see the front
	# of the Character, when not inputing movement.
	if camera and direction and not Input.is_action_pressed(&"CAMERA_ROTATION"):
		camera.look_forward(delta, (Vector3(0, 0, 1)))
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = 0
			velocity.z = 0
	else:
		# if not on the ground, lerp the velocity towards the direction rather than setting it
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 2.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 2.0)
	
	# TODO: there'a bug with this where the rotation flips around at a certain point
	var rotate_dir: float = get_rotate_direction()
	rotate_y(rotate_dir * rotation_speed * delta / 2.0)

	move_and_slide()

	if _jump_counter < number_of_jumps and is_on_floor():
		_jump_counter = number_of_jumps


@rpc("any_peer", "call_local", "reliable")
func use_ability_by_id(ability_id: String, entity_id: String) -> void:
	var ability: Ability = AbilityDatabase.get_by_id(ability_id)
	var found_target: Entity = get_tree().get_nodes_in_group("ENTITY").filter(
		func (entity: Entity) -> bool: return entity.name == entity_id
	).pop_at(0)
	use_ability(ability, found_target)


# TODO: something I don't like about this as it stands right now is that this has low flexibility for ground targetted abilities - probably need another method
#		I'd like to probably add some way for an ability to have a set of dynamic parameters which the UI can query / use. 
# 		For example a Fireball which simply has a target, the UI will assume the target is the target. 
# 			then perhaps if the user does not have a target it will allow the selection of a target(?)
# 		Then for something like Death and Decay it will query for a ground location 
func use_ability(original_ability: Ability, ability_target: Entity) -> void:
	if ! original_ability:
		print('missing ability!')
		return
	if ! ability_target:
		print('missing target')
		return

	# prevent the using of passive abilities
	if original_ability.effects.is_empty():
		print('Can\'t use this ability!')
		return

	var ability: Ability = original_ability.duplicate(true) 
	# for aura in auras:
	# 	if aura is AbilityModification && aura.isValid(ability):
	# 		aura.apply(ability) # this will modify ability properties

	# TODO: thinking of auras that modify the cost/cooldown/etc. of an ability, we should probably search the auras for those effects and apply them


	# TODO: I don't like how we have to attach many of the requisites to the ability, can we just determine these here hardcoded?
	# 		Basic requisites are in-range, line-of-sight, spell-known
	#		Eventually want to make sure the target is valid (heals to friends, damage to foes, /untargetable things)
	for requisite: AbilityRequisite in ability.requisites:
		if not requisite.can_use_ability(self, ability_target, ability):
			# emit out that the ability can't be used? - probably definitely YES. Some sort of "Warning Area" UI element should wait and listen for these errors to represent
			Logger.warn(requisite.as_message(ability))
			return

	for cost: ResourceCost in ability.resource_costs:
		var pool: StatPool = stats_component.resources.get(cost.resource_type)
		if pool.current_value < cost.quantity:
			Logger.warn('Not enough ', ResourceType.as_string(cost.resource_type))
			return

	if ability.global_cooldown > 0:
		cooldowns.set_global_cooldown(ability.global_cooldown)

	if ability.cast_time > 0:
		# TODO: how to interupt casting if player is moving
		Logger.info('starting casting ' + str(ability))
		var cast_aura: CastingAura = CastingAura.new()
		cast_aura.load(self, ability_target, ability)
		aura_component.add_aura(cast_aura)
	else:
		activate_ability(ability, ability_target)

func activate_ability(ability: Ability, ability_target: Entity) -> void:
	if ability.cooldown > 0:
		cooldowns.set_cooldown(ability)

	for cost: ResourceCost in ability.resource_costs:
		var pool: StatPool = stats_component.resources.get(cost.resource_type)
		if pool.current_value >= cost.quantity:
			pool.current_value -= cost.quantity
		else:
			print('Not enough ', ResourceType.as_string(cost.resource_type))
			return

	# TODO: search the auras for anything that would affect the ability

	var context: EffectContext = EffectContext.new(self, ability_target)
	context.source_ability = ability
	
	for aura: BaseAura in aura_component.get_auras():
		if aura is OnAbilityAura and aura.should_activate(context):
			aura.add_effects(ability.effects)

	for effect: _AbilityEffect in ability.effects:
		var effect_ctx: EffectContext = EffectContext.new(self, ability_target)
		effect_ctx.source_ability = ability
		effect.apply(effect_ctx)

func _on_health_changed (value: float) -> void:
	# TODO: should this spill any guts just on any hit?
	if value == 0:
		if is_alive:
			health_bar.visible = false
			death.emit()
		else: model._on_death()

		is_alive = false
