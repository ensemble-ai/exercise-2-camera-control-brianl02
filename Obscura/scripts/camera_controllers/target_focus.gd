class_name TargetFocus
extends CameraControllerBase

@export var lead_speed:float
@export var catchup_delay_duration:float
@export var catchup_speed:float
@export var leash_distance:float

@onready var time_passed:float = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	position = target.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !current:  # process only runs when camera is selected
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
	var catchup_direction:Vector2 = distance.normalized() # direction vector pointing from camera to vessel
	# direction of vessel's movement
	var input_direction = Vector2(target.velocity.normalized().x, target.velocity.normalized().z)
	var movement = Vector2(0,0)
	
	# if vessel has stopped moving (use is_equal_approx b/c float values are not accurate)
	if is_equal_approx(target.velocity.length(),0):
		
		if (time_passed < catchup_delay_duration):
		# if the delay time has not passed yet (use delta to keep track)
			time_passed += delta
			
		elif (time_passed >= catchup_delay_duration): 
		# delay time passed, move camera back towards vessel
			movement = catchup_direction * catchup_speed
			global_position.x += movement.x * delta
			global_position.z += movement.y * delta
			
		if round(distance.length()) == 0:
		# if camera has made it back to vessel, center camera on vessel, reset timer
		# use round b/c the distance between the two will not be exactly 0
			global_position.x = target.global_position.x
			global_position.z = target.global_position.z
			time_passed = 0

	else: # vessel is currently moving
		
		if target.velocity.length() > target.BASE_SPEED * 2:
		# if vessel is in hyperspeed
		# set the camera to be at leash distance away from vessel in input direction 
		# do this so camera position will remain correct even when in hyperspeed
		# use base speed * 2 b/c vessel speed sometimes exceeds base speed even when not in hyperspeed
			movement = input_direction * leash_distance
			global_position.x = tpos.x + movement.x
			global_position.z = tpos.z + movement.y
			
		else: # vessel NOT in hyperspeed
			
			if distance.length() < leash_distance:
			# camera is not maximum distance away yet
			# travel in front of vessel at faster speed than vessel
				movement = input_direction * lead_speed
				global_position.x += movement.x * delta
				global_position.z += movement.y * delta
				
			elif distance.length() >= leash_distance:
			# camera has reached maximum distance 
			
				if (!is_equal_approx(catchup_direction.x,-1*input_direction.x) || !is_equal_approx(catchup_direction.y,-1*input_direction.y)):
				# if the camera is NOT in front of the vessel in the direction of its movement
				# sometimes camera is already at leash distance, but vessel changes direction w/o stopping
				# this if statement makes it so camera will shift position when this happens
				# use catchup_direction and input_direction vectors
				# if camera position is right the two should be pointing in exact opposite directions
				# use is_equal_approx because float values may not exactly match up
				
				
					if (abs(abs(catchup_direction.x)-abs(input_direction.x)) <= 0.4) || (abs(abs(catchup_direction.y)-abs(input_direction.x)) <= 0.4) :
					# if camera is close enough to its appropriate position
					# directly set its position to the correct spot
					# check this by comparing catchup_direction and input_direction
					# see if they are almost the exact same vector
					# do this because float values not exact 
					# code will continue adjusting camera position even when it is in the right spot
					# forcing camera to "lock into" correct spot prevents jittering
						movement = input_direction * leash_distance
						global_position.x = tpos.x + movement.x
						global_position.z = tpos.z + movement.y
						
					else: # camera is not at right spot yet
					# move the camera towards its appropriate spot
					# use vector addition to find direction from current camera spot to correct spot
					# add vector pointing back to vessel and vector of vessel movement to make new direction vector
						movement = (catchup_direction + input_direction).normalized() * (lead_speed) *0.5
						# note: i added the * 0.5 to accentuate the vibrating effect the vessel 
						# gets when it shifts position, you don't actually need it i just thought
						# it looked cool
						global_position.x += movement.x * delta
						global_position.z += movement.y * delta
						
				else: # camera is at leash distance AND in correct spot
				# continue on path of vessel movement, maintaining leash distance
					movement = input_direction * target.velocity.length()
					global_position.x += movement.x * delta
					global_position.z += movement.y * delta
				
		
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
