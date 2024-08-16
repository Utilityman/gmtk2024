class_name Ability extends Resource

# TODO: 1.5 is cool? or should it be 1.25 or even 1?
const DEFAULT_GLOBAL_COOLDOWN: float = 1.5
const MELEE_RANGE: float = 2.0

@export var id: String

@export_category("Description")
@export var name: String
@export_multiline var description: String
@export var icon: Texture2D
# TODO: icon as a resource

@export_category("Data")
@export var use_range: float = MELEE_RANGE
@export_range(0, 10.0, 0.1, "or_greater") var cast_time: float = 0.0
@export_range(0, 30.0, 0.5, "or_greater") var cooldown: float = 0.0
# @export var cooldown_key: Id ? 
@export_range(0, 30.0, 0.5, "or_greater") var global_cooldown: float = DEFAULT_GLOBAL_COOLDOWN
@export var off_global_cooldown: bool = false

# TODO: any weay to load in default requisites?
#       if not we should transform the basic requisites into an all-in-one catch-all
@export var requisites: Array[AbilityRequisite] = []
# @export var target_requisites: Array[TargetRequisite] 
# TODO: right before bed one night I thought about if abilities were instead passed a generic "target: Node3D" param then 
#       a list of target requisites could then validate that the target is valid. 
#       Then for ground effects they could just pass the node3d that is the destination for an ability to use
#       Or for healing effects it would prevent the source to heal enemy targets (the UI could potentially be smart enough to know to auto self-heal )
@export var resource_costs: Array[ResourceCost] = []

@export_category("Effects")
@export var effects: Array[_AbilityEffect] = []
@export var passives: Array[BaseAura] = [] # TODO: let this hold auras which will be inserted into the AuraComponent 
# - Judgement ability comes with passive to help proc it 
# - Ravage ability comes with the passive that reduces its cooldown on physical ability hits

# resource_cost
# school
# target type
