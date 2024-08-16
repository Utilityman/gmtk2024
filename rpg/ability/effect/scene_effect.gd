class_name SceneEffect extends _AbilityEffect

@export var scene_data: ReplicatedSceneData
@export var apply_to_self: bool = true
@export var duration: float = 5.0

func apply (context: EffectContext) -> void:
    var source: Entity = context.source
    var target: Entity = context.target
    var entity: Entity = target if ! apply_to_self else source

    var scene: ReplicatedScene3D = scene_data.as_replicated_scene()
    entity.projectile_source.add_child(scene, true)
    await scene.get_tree().create_timer(duration).timeout
    scene.queue_free()