class_name Autoscrollr
extends CameraControllerBase

@export var box_width:float = 27.0
@export var box_height:float = 15.0

@export var top_left = Vector2(-27, -15)
@export var bottom_right = Vector2(27, 15)
@export var autoscroll_speed = Vector3(0.1, 0, 0)

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
	
	target.global_position += autoscroll_speed
	global_position += autoscroll_speed
	
	#boundary checks
	
	#if(position.x < top_left.x):
		#print ("left boundary hit")
	#print(position)
	#left
	var diff_between_left_edges = (tpos.x - target.WIDTH / 2.0) - (cpos.x - box_width)
	if diff_between_left_edges < 0:
		target.global_position.x -= diff_between_left_edges
	#right
	
	var diff_between_right_edges = (tpos.x + target.WIDTH / 2.0) - (cpos.x + box_width)
	if diff_between_right_edges > 0:
		target.global_position.x -= diff_between_right_edges

	#top
	var diff_between_top_edges = (tpos.z - target.HEIGHT / 2.0) - (cpos.z - box_height)
	if diff_between_top_edges < 0:
		target.global_position.z -= diff_between_top_edges
	#bottom
	var diff_between_bottom_edges = (tpos.z + target.HEIGHT / 2.0) - (cpos.z + box_height)
	if diff_between_bottom_edges > 0:
		target.global_position.z -= diff_between_bottom_edges
		
	#print(tpos.x)
	
	super(delta)


func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	var left:float = -27
	var right:float = 27
	var top:float = -15
	var bottom:float = 15
	
	
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
