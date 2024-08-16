class_name DamageEffect extends _AbilityEffect

enum Using { MainHand, OffHand, Both }

static var random: RandomNumberGenerator = RandomNumberGenerator.new()

@export_category("Damage Modifiers")
@export_range(0.0, 999.0, 1.0, "or_greater") var flat_damage: float = 0.0
@export_range(0.0, 10.0, 0.5, "or_greater") var level_ratio: float = 1.0
@export_range(0.0, 3.0, 0.05, "or_greater") var spell_power_ratio: float = 0.0
@export_range(0.0, 3.0, 0.05, "or_greater") var attack_power_ratio: float = 0.0
# TODO: probably want flat ratios for all primary stats (and perhaps even stuff like armor too)
# TODO: for elemental attacks, how will that work?
# TODO: type of damage and such? Physical, Magical - then Fire, Frost, Nature, etc.

@export_category("Weapon Damage")
@export_range(0.0, 3.0, 0.05, "or_greater") var weapon_damage_ratio: float = 0.0
@export var using: Using

@export_category("Damage Type")
@export var type: String # TODO: needs to be an enum
@export var sub_type: String # TODO: needs to be an enum


# something I don't like here is that theoretically we have no way to tell what this damage is from - another reason for an EffectContext???
# - this also isn't great thinking about a damage log
func apply (context: EffectContext) -> void:
	var source: Entity = context.source
	var target: Entity = context.target

	var damage: float = 0.0
	damage += flat_damage
	if source:
		damage += source.info.level * level_ratio
		# damage += source.something.spell_power * spell_power_ratio
		# damage += source.something.attack_power * attack_power_ratio
		# damage += source.equipment.something * weapon_damage_ratio

		for aura: OnHitAura in source.aura_component.get_auras().filter(func (aura: BaseAura) -> bool: return aura is OnHitAura):
			if aura.should_activate(context):
				aura.on_activate(context)

		var percent_modification: float = 0.0
		for aura: DamageModAura in source.aura_component.get_auras().filter(func (aura: BaseAura) -> bool: return aura is DamageModAura):
			if aura.should_activate(context):
				damage += aura.flat_modification
				percent_modification += aura.percent_modification
		damage += ceil(damage * percent_modification)

	# TODO: iterate over target's auras to see if any would affect the damage

	# TODO: apply mitigation using the target's armor or ward
	# TODO: apply damage to any shields the target has

	# TODO: export the variance number? default is plus or minus 5% variance
	var variance: int =  int(damage / 20.0)
	var variance_damage: int = max(0, random.randi_range(int(damage) - variance, int(damage) + variance))
	target.stats_component.health.current -= max(0, variance_damage)

	# TODO: if any auras cause additional effects, apply those as well
	#       (thorns, onHit additional damage, onHit cooldown reduction, etc.)
