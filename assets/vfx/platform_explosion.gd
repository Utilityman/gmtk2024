class_name PlatformExplosion extends Node3D

@onready var particles: GPUParticles3D = $GPUParticles3D
@onready var screwparticles: GPUParticles3D = $Screwslposion/GPUParticles3D
func explode () -> void:
	particles.emitting = true

func rainScrews() -> void:
	screwparticles.emitting = true