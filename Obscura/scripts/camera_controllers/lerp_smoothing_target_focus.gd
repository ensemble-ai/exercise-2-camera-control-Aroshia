class_name LerpSmoothFocus
extends CameraControllerBase

var multiplier:float = 1.8
var timer_start = false

@export var follow_speed:float = target.BASE_SPEED*0.1


@export var lead_speed:float = target.BASE_SPEED*multiplier
@export var lead_speed_hyper:float = target.HYPER_SPEED*multiplier
@export var catchup_delay_duration:float = 1.0
@export var catchup_speed:float = target.BASE_SPEED*1.2
@export var leash_distance:float = 25.0

var zero = Vector3(0, 0, 0)

func _ready() -> void:
	super()
	position = target.position
	

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

func _process(delta: float) -> void:
	if !current:
		return
	
	if draw_camera_logic:
		draw_logic()
		
	if timer_start:
		return
	
	var tpos = target.global_position
	var cpos = global_position
	
	
	tpos.y = 0
	cpos.y = 0
	
	#set y-values for target and camera position to 0 so the diff in camera and vessel height isnt affecting the direction and length
	
	var altdirection = (tpos-cpos).normalized()
	var direction = get_input_direction()
	var length = (tpos-cpos).length()

	#for direction, when working with vectors, do a vector3.normalize and it gives the direction of the vector as a unit vector
	#|target.velocity| to figure out if target is moving
	if(!target.velocity.is_zero_approx() and length < leash_distance): 
		print("cpos: %s"%str(cpos))
		print("tpos: %s"%str(tpos))
		print("tpos - cpos: %s"%str(tpos-cpos))
		print("altdirection: %s"%str(altdirection))
		global_position += direction*delta*lead_speed
	#elif(!target.velocity.is_zero_approx() and length > leash_distance and direction.is_equal_approx(altdirection)):
		#print("input direction: %s" %str(direction))
		#print("tpos-cpos direction: %s" %str(altdirection))
		#global_position += direction*delta*target.BASE_SPEED
	elif(!target.velocity.is_zero_approx() and !direction.is_equal_approx(altdirection)):
		print("wrong side")
		global_position += (direction+altdirection)*delta*target.BASE_SPEED
	elif(target.velocity.is_zero_approx() and !cpos.is_equal_approx(tpos)):
		#print("global_position")
		#await get_tree().create_timer(1.0).timeout
		global_position += altdirection*delta*catchup_speed
		print("global_position: %s"%str(global_position))
	else:
		global_position = tpos
	#boundary checks

		
	super(delta)

func wait (seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout

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
