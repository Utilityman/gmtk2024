class_name _AbilityEffect extends Resource

# TODO: something that is a little bit annoying here is that 
#       if we want to have the environment do damage to the player
#       that we're basically going to need to write another entire 
#       effect system that uses separately unique effects
#       
#       this may be fine as something like "damage_effect" which uses a lot of
#       source character information to determine effects realistically wouldn't be needed
#       by Lava. Or a arrow trap projectile.
# 
#       All the same, it is curious to think about what could perhaps be


# TODO: additional effects
# - PhysicsEffect
# - ConsumeAuraEffect
# - AuraExtendEffect (This would be like an ability which doesn't apply an aura but extends a specific type of existing aura)
# - CooldownEffect (reduce cooldown of a specific ability)
# - ResourceEffect (grant/drain of a specific resource)

@export var debug: bool = false
# TODO: so many effects have the "apply_to_self" property, can this be made common or does it not make sense?

func apply (_context: EffectContext) -> void:
    if debug: print(self)