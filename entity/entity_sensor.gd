class_name EntitySensor extends Area3D

var entities: Array[Entity] = []:
    get:
        entities.sort_custom(func (entity1: Entity, entity2: Entity) -> int: 
            var dst1: float = global_position.distance_squared_to(entity1.global_position)
            var dst2: float = global_position.distance_squared_to(entity2.global_position)
            return dst1 > dst2
        )
        return entities

func _ready() -> void:
    body_entered.connect(_on_body_entered)
    body_exited.connect(_on_body_exited)

func _on_body_entered (body: Node3D) -> void:
    if body is Entity:
        var entity: Entity = body as Entity
        if not entities.has(entity):
            entities.append(entity)

func _on_body_exited (body: Node3D) -> void:
    if body is Entity:
        entities.erase(body)
