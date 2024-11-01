class_name PushZone
extends CameraControllerBase

@export var push_ratio:float
@export var pushbox_top_left:Vector2
@export var pushbox_bottom_right:Vector2
@export var speedup_zone_top_left:Vector2
@export var speedup_zone_bottom_right:Vector2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# hello there (nov 1 2:15 am)
	super()
	position = target.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !current: # process only runs when camera is selected
		return
	
	if draw_camera_logic:
		draw_logic()
		
	if just_switched: # centers camera on vessel after you toggle to it 
		global_position.x = target.global_position.x
		global_position.z = target.global_position.z
		just_switched = false
		
	var tpos = target.global_position
	var cpos = global_position
	
	# use normal vector of vessel velocity to extract direction of vessel movement
	var input_direction = Vector2(target.velocity.normalized().x, target.velocity.normalized().z)
	var movement = Vector2(0,0)
	
	# variables used to check if vessel is in speedup zone
	var diff_between_left_edges_speedup = (tpos.x - target.WIDTH / 2.0) - (cpos.x + speedup_zone_top_left.x)
	var diff_between_right_edges_speedup = (tpos.x + target.WIDTH / 2.0) - (cpos.x + speedup_zone_bottom_right.x)
	var diff_between_top_edges_speedup = (tpos.z + target.HEIGHT / 2.0) - (cpos.z + speedup_zone_top_left.y)
	var diff_between_bottom_edges_speedup = (tpos.z - target.HEIGHT / 2.0) - (cpos.z - speedup_zone_top_left.y)
	
	# variables used to check if vessel is touching edge of push box
	var diff_between_left_edges_pushbox = (tpos.x - target.WIDTH / 2.0) - (cpos.x + pushbox_top_left.x)
	var diff_between_right_edges_pushbox = (tpos.x + target.WIDTH / 2.0) - (cpos.x + pushbox_bottom_right.x)
	var diff_between_top_edges_pushbox = (tpos.z + target.HEIGHT / 2.0) - (cpos.z + pushbox_top_left.y)
	var diff_between_bottom_edges_pushbox = (tpos.z - target.HEIGHT / 2.0) - (cpos.z - pushbox_top_left.y)
	
	if (diff_between_left_edges_speedup < 0 || diff_between_right_edges_speedup > 0 || diff_between_top_edges_speedup > 0 || diff_between_bottom_edges_speedup < 0):
	# if vessel is in the speedup zone, set its velocity to vessel speed * push ratio in direction of vessel movement
		movement = input_direction * target.velocity.length() * push_ratio
		
	if (diff_between_left_edges_pushbox <= 0):
	# if vessel touching left edge of pushbox, move camera in x direction at vessel's x velocity
	# accomplish by detecting if vessel has left box from left side and then moving camera to vessel's postion
		movement.x = diff_between_left_edges_pushbox/delta
	
	if (diff_between_right_edges_pushbox >= 0):
	# if vessel touching right edge of pushbox, move camera in x direction at vessel's x velocity
	# accomplish by detecting if vessel has left box from right side and then moving camera to vessel's postion
		movement.x = diff_between_right_edges_pushbox/delta
	
	if (diff_between_top_edges_pushbox >= 0):
	# if vessel touching top edge of pushbox, move camera in y direction at vessel's y velocity
	# accomplish by detecting if vessel has left box from top side and then moving camera to vessel's postion
		movement.y = diff_between_top_edges_pushbox/delta
	
	if (diff_between_bottom_edges_pushbox <= 0):
	# if vessel touching bottom edge of pushbox, move camera in y direction at vessel's y velocity
	# accomplish by detecting if vessel has left box from bottom side and then moving camera to vessel's postion
		movement.y = diff_between_bottom_edges_pushbox/delta
	
	# update camera's position based on calculations
	global_position.x += movement.x * delta
	global_position.z += movement.y * delta
	
	super(delta)

func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	var left_pushbox:float = pushbox_top_left.x
	var right_pushbox:float = pushbox_bottom_right.x
	var top_pushbox:float = -pushbox_top_left.y
	var bottom_pushbox:float = -pushbox_bottom_right.y
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(Vector3(right_pushbox, 0, top_pushbox))
	immediate_mesh.surface_add_vertex(Vector3(right_pushbox, 0, bottom_pushbox))
	
	immediate_mesh.surface_add_vertex(Vector3(right_pushbox, 0, bottom_pushbox))
	immediate_mesh.surface_add_vertex(Vector3(left_pushbox, 0, bottom_pushbox))
	
	immediate_mesh.surface_add_vertex(Vector3(left_pushbox, 0, bottom_pushbox))
	immediate_mesh.surface_add_vertex(Vector3(left_pushbox, 0, top_pushbox))
	
	immediate_mesh.surface_add_vertex(Vector3(left_pushbox, 0, top_pushbox))
	immediate_mesh.surface_add_vertex(Vector3(right_pushbox, 0, top_pushbox))
	
	var left_speedup:float = speedup_zone_top_left.x
	var right_speedup:float = speedup_zone_bottom_right.x
	var top_speedup:float = -speedup_zone_top_left.y
	var bottom_speedup:float = -speedup_zone_bottom_right.y
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(Vector3(right_speedup, 0, top_speedup))
	immediate_mesh.surface_add_vertex(Vector3(right_speedup, 0, bottom_speedup))
	
	immediate_mesh.surface_add_vertex(Vector3(right_speedup, 0, bottom_speedup))
	immediate_mesh.surface_add_vertex(Vector3(left_speedup, 0, bottom_speedup))
	
	immediate_mesh.surface_add_vertex(Vector3(left_speedup, 0, bottom_speedup))
	immediate_mesh.surface_add_vertex(Vector3(left_speedup, 0, top_speedup))
	
	immediate_mesh.surface_add_vertex(Vector3(left_speedup, 0, top_speedup))
	immediate_mesh.surface_add_vertex(Vector3(right_speedup, 0, top_speedup))
	
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
