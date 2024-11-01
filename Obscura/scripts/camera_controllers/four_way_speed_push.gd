class_name PushZone
extends CameraControllerBase

@export var speedup_zone_top_left = Vector2(-5,-5)
@export var speedup_zone_bottom_right = Vector2(5,5)
@export var pushbox_top_left = Vector2(-15,-15)
@export var pushbox_bottom_right = Vector2(15,15)
@export var push_ratio:float = 0.8


@export var small_box_width:float = 10.0
@export var small_box_height:float = 10.0
@export var large_box_width:float = 30.0
@export var large_box_height:float = 30.0


var zero = Vector3(0, 0, 0)

func get_input_direction() -> Vector3:
	var direction = Vector3.ZERO
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.z += 1
	if Input.is_action_pressed("ui_up"):
		direction.z -= 1
	return direction.normalized()

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
	
	tpos.y = 0
	cpos.y = 0
	
	var altdirection = get_input_direction()
	var direction = (tpos-cpos).normalized()
	var length = (tpos-cpos).length()
	
	#left
	var asdf = (tpos.x) - (cpos.x)
	var diff_between_left_edges_small = (tpos.x - target.WIDTH / 2.0) - (cpos.x + speedup_zone_top_left.x)
	var diff_between_left_edges_large = (tpos.x - target.WIDTH / 2.0) - (cpos.x + pushbox_top_left.x)
	#if its between the boxes
	if(diff_between_left_edges_small < 0 and diff_between_left_edges_large > 0): 
		global_position += altdirection*delta*target.BASE_SPEED*push_ratio
	#if it's touching the edge of the big box
	elif(diff_between_left_edges_large < 0):
		global_position.x += altdirection*delta*target.BASE_SPEED
		global_position.z -= altdirection*delta*target.BASE_SPEED*push_ratio
		


	#right
	var diff_between_right_edges_small = (tpos.x + target.WIDTH / 2.0) - (cpos.x + speedup_zone_bottom_right.x)
	var diff_between_right_edges_large = (tpos.x + target.WIDTH / 2.0) - (cpos.x + pushbox_bottom_right.x)
	if diff_between_right_edges_small > 0 and diff_between_right_edges_large < 0:
		global_position += altdirection*delta*target.BASE_SPEED*push_ratio
	elif(diff_between_right_edges_large > 0):
		global_position.x += diff_between_right_edges_large

	#top
	var diff_between_top_edges_small = (tpos.z - target.HEIGHT / 2.0) - (cpos.z + speedup_zone_top_left.y)
	var diff_between_top_edges_large = (tpos.z - target.HEIGHT / 2.0) - (cpos.z + pushbox_top_left.y)
	
	if diff_between_top_edges_small < 0 and diff_between_top_edges_large > 0:
		global_position += altdirection*delta*target.BASE_SPEED*push_ratio
	elif(diff_between_top_edges_large < 0):
		global_position.z += diff_between_top_edges_large
	
	#bottom
	var diff_between_bottom_edges_small = (tpos.z + target.HEIGHT / 2.0) - (cpos.z + speedup_zone_bottom_right.y)
	var diff_between_bottom_edges_large = (tpos.z + target.HEIGHT / 2.0) - (cpos.z + pushbox_bottom_right.y)
	
	if diff_between_bottom_edges_small > 0 and diff_between_bottom_edges_large < 0:
		global_position += altdirection*delta*target.BASE_SPEED*push_ratio
	elif(diff_between_bottom_edges_large > 0):
		global_position.z += diff_between_bottom_edges_large
	#
	super(delta)


func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	var sleft:float = -small_box_width / 2
	var sright:float = small_box_width / 2
	var stop:float = -small_box_width / 2
	var sbottom:float = small_box_width / 2
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(Vector3(sright, 0, stop))
	immediate_mesh.surface_add_vertex(Vector3(sright, 0, sbottom))
	
	immediate_mesh.surface_add_vertex(Vector3(sright, 0, sbottom))
	immediate_mesh.surface_add_vertex(Vector3(sleft, 0, sbottom))
	
	immediate_mesh.surface_add_vertex(Vector3(sleft, 0, sbottom))
	immediate_mesh.surface_add_vertex(Vector3(sleft, 0, stop))
	
	immediate_mesh.surface_add_vertex(Vector3(sleft, 0, stop))
	immediate_mesh.surface_add_vertex(Vector3(sright, 0, stop))
	
	var lleft:float = -large_box_width / 2
	var lright:float = large_box_width / 2
	var ltop:float = -large_box_width / 2
	var lbottom:float = large_box_width / 2
	
	#immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(Vector3(lright, 0, ltop))
	immediate_mesh.surface_add_vertex(Vector3(lright, 0, lbottom))
	
	immediate_mesh.surface_add_vertex(Vector3(lright, 0, lbottom))
	immediate_mesh.surface_add_vertex(Vector3(lleft, 0, lbottom))
	
	immediate_mesh.surface_add_vertex(Vector3(lleft, 0, lbottom))
	immediate_mesh.surface_add_vertex(Vector3(lleft, 0, ltop))
	
	immediate_mesh.surface_add_vertex(Vector3(lleft, 0, ltop))
	immediate_mesh.surface_add_vertex(Vector3(lright, 0, ltop))
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	
	
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
