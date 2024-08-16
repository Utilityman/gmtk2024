class_name ProjectileData extends Resource

# TODO use me?
enum FollowStyle { follow_target, follow_direction }
enum HitStyle { any, only_target }

@export_category("Shape and Appearance")
@export var shape: Shape3D
@export var visual_effects: Array[ReplicatedSceneData]

@export_category("Behavior")
@export var direction: Vector3
@export var use_source_direction: bool = false # TODO: this means whether or not to move in the direction that the player is facing
@export var start_from_source: bool = true # TODO: this is whether the projectile spawns on the player or their target
@export_enum("follow_target", "follow_direction") var follow_style: String = "follow_target"
@export_range(0.0, 30.0, 0.1, "or_greater") var speed: float = 15.0
@export_range(0.0, 10.0, 0.5, "or_greater") var acceleration: float = 1.0
@export_range(0.0, 30.0, 0.5, "or_greater") var life_time: float = 15.0
@export_enum("any", "only_target", "none") var hit_style: String = "only_target"
@export var time_to_free: float = 0
# @export var y_curve: GraphOrWhatever (to provide an arc to the projectile)