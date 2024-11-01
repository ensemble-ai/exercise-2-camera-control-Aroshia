class_name PosLockLerp
extends CameraControllerBase

@export var follow_speed:float = target.BASE_SPEED*0.1
@export var follow_speed_hyper:float = target.HYPER_SPEED*0.1
@export var catchup_speed:float = target.BASE_SPEED*0.3
@export var leash_distance:float = 25.0

var zero = Vector3(0, 0, 0)

func _ready() -> void:
	super()
	position = target.position
	

func _process(delta: float) -> void:
	if !current:
		return
	
	if draw_camera_logic:
		draw_logic()
	
	var tpos = target.global_position
	var cpos = global_position
	
	var direction = (tpos-cpos).normalized()
	var length = (tpos-cpos).length()
	#print(length)
	#for direction, when working with vectors, do a vector3.normalize and it gives the direction of the vector as a unit vector
	#|target.velocity| to figure out if target is moving
	if(target.velocity != zero and length < leash_distance): #use tpos-cpos to find a single number
		#print("inside leash")
		global_position += length*direction*delta*follow_speed
	elif(target.velocity != zero): #use tpos-cpos to find a single number
		#print("outside leash")
		global_position += length*direction*delta*follow_speed_hyper
	elif(target.velocity == zero):
		#print("still")
		global_position += length*direction*delta*catchup_speed
	#if(length > leash_distance): #use tpos-cpos to find a single number
		#print("outside leash")
	#elif(length < leash_distance): #use tpos-cpos to find a single number
		#print("inside leash")

	
	#boundary checks
	##left
	#var diff_between_left_edges = (tpos.x) - (cpos.x)
	#if diff_between_left_edges < 0:
		#global_position.x += diff_between_left_edges
	##right
	#var diff_between_right_edges = (tpos.x) - (cpos.x)
	#if diff_between_right_edges > 0:
		#global_position.x += diff_between_right_edges
	##top
	#var diff_between_top_edges = (tpos.z) - (cpos.z)
	#if diff_between_top_edges < 0:
		#global_position.z += diff_between_top_edges
	##bottom
	#var diff_between_bottom_edges = (tpos.z) - (cpos.z)
	#if diff_between_bottom_edges > 0:
		#global_position.z += diff_between_bottom_edges
		
	super(delta)


func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(Vector3(0, 0, -5))
	immediate_mesh.surface_add_vertex(Vector3(0, 0, 5))
	
	immediate_mesh.surface_add_vertex(Vector3(5, 0, 0))
	immediate_mesh.surface_add_vertex(Vector3(-5, 0, 0))
	
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
