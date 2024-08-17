class_name PlatformExplosion extends Node3D

@onready var particles: GPUParticles3D = $GPUParticles3D

func explode () -> void:
	particles.emitting = true
