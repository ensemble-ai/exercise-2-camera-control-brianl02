class_name PositionLock
extends CameraControllerBase


# Called when the node enters the scene tree for the first time.
func _ready() -> void: 
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
	
	# set the camera to exactly on top of vessel at all times
	if (tpos.x != cpos.x) :
		global_position.x = tpos.x
	if (tpos.z != cpos.z) :
		global_position.z = tpos.z
				
	super(delta)
	
	
func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(Vector3(0, 0, 5))
	immediate_mesh.surface_add_vertex(Vector3(0, 0, -5))
	
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
