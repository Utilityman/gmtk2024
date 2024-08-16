class_name AreaEffectData extends Resource

@export_category("Shape and Appearance")
@export var shape: Shape3D
# TODO: appearance? I'm thinking that there may be "graphics_effect.gd (extends _AbilityEffect)" which might pack gfx stuff separately??? 

@export_category("Behavior")
@export var max_targets: int = 0 # 0 is uncapped # TODO: this is not implemented
@export var hit_self: bool = false
@export var top_level: bool = false # this would really only matter if there are area effects that last a duration
# TODO: what other behavior might be fun for an area effect? 
# - TODO: what about an area effect that lasts a duration?
#           there's some logical battle here because theoretically something with a duration could be an aura that pulses (EffectOverTimeAura)
#           but alternatively if there's a ground effect where the target was standing, keeping this as a separate Node3D in the scene would be better