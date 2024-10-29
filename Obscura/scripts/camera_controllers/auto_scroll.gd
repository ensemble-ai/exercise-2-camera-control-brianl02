class_name AutoScroll
extends CameraControllerBase

@export var top_left:Vector2
@export var bottom_right:Vector2
@export var autoscroll_speed:Vector3


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	position = target.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !current:
		return
	
	if draw_camera_logic:
		draw_logic()
	
	var tpos = target.global_position
	var cpos = global_position
	
	var diff_between_left_edges = (tpos.x - target.WIDTH / 2.0) - (cpos.x + top_left.x)
	if diff_between_left_edges < 0:
		target.global_position.x -= diff_between_left_edges
	
	var diff_between_right_edges = (tpos.x + target.WIDTH / 2.0) - (cpos.x + bottom_right.x)
	if diff_between_right_edges > 0:
		target.global_position.x -= diff_between_right_edges
	
	var diff_between_top_edges = (tpos.z + target.HEIGHT / 2.0) - (cpos.z + top_left.y)
	if diff_between_top_edges > 0:
		target.global_position.z -= diff_between_top_edges
	
	var diff_between_bottom_edges = (tpos.z - target.HEIGHT / 2.0) - (cpos.z - top_left.y)
	if diff_between_bottom_edges < 0:
		target.global_position.z -= diff_between_bottom_edges
	
	var travel_distance = delta * autoscroll_speed.x  
	global_position.x += travel_distance
	
	super(delta)
		
func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	var left:float = top_left.x
	var right:float = bottom_right.x
	var top:float = -top_left.y
	var bottom:float = -bottom_right.y
	
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
