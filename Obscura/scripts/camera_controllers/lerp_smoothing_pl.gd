class_name LerpSmoothingPL
extends CameraControllerBase

@export var follow_speed:float
@export var catchup_speed:float
@export var leash_distance:float


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
	
	var distance = Vector2(tpos.x - cpos.x, tpos.z - cpos.z) # distance from camera to vessel
	var direction:Vector2 = distance.normalized() # direction vector pointing from camera to vessel
	var movement = Vector2(0,0)

	if is_equal_approx(target.velocity.length(),0) && round(distance.length()) != 0:
	# if vessel stopped and camera hasn't caught up to vessel position yet
	# move camera towards vessel at catchup speed
	# use is_equal_approx and round b/c float values aren't accurate
		movement = direction * catchup_speed
		global_position.x += movement.x * delta
		global_position.z += movement.y * delta
		
	elif !is_equal_approx(target.velocity.length(),0) && round(distance.length()) != 0:
	# if vessel is moving 
	
		if target.velocity.length() > target.BASE_SPEED * 2:
		# if vessel is in hyperspeed
		# set the camera to be at leash distance behind vessel
		# do this so camera position will remain correct even when in hyperspeed
		# use base speed * 2 b/c vessel speed sometimes exceeds base speed even when not in hyperspeed
		# find direction of vessel's movement based on its velocity
		# place camera in opposite direction of vessel's movement
			var input_direction = Vector2(target.velocity.normalized().x, target.velocity.normalized().z)
			movement = -1 * input_direction * leash_distance
			global_position.x = tpos.x + movement.x
			global_position.z = tpos.z + movement.y
		
		else: # vessel NOT in hyperspeed
		
			if distance.length() <= leash_distance:
			# if vessel not max distance away from camera yet
			# move camera in direction of vessel 
				movement = direction * follow_speed
				global_position.x += movement.x * delta
				global_position.z += movement.y * delta
				
			elif distance.length() > leash_distance:
			# vessel has reached max distance away
			# maintain max distance by setting camera speed to vessel speed
				movement = direction * target.velocity.length()
				global_position.x += movement.x * delta
				global_position.z += movement.y * delta
			
	else: 
	# checks for when camera is roughly in same position as vessel
	# directly set its position to right on top of vessel
	# used to prevent jittering bug caused by using float values
	# b/c you use float values, sometimes even when camera is in same spot as vessel, it still tries to adjust position 
		global_position.x = target.global_position.x
		global_position.z = target.global_position.z
			
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
