extends CharacterBody2D


const SPEED = 300.0
@export var player: String = "player_1"
@export var ball: Node2D

@export_range(0.0, 1.0) var difficulty: float = 0.5
@export var max_error_margin: float = 100.0

var future_y: float = 0.0
var frame_count = 0

var debug_points: PackedVector2Array = []

var needs_new_prediction := true
func _ready() -> void:
    future_y = position.y

func _physics_process(delta: float) -> void:
    # Get the input direction and handle the movement/deceleration.
    # As good practice, you should replace UI actions with custom gameplay actions.
    if player != "computer":
        if Input.is_action_pressed(player + "_move_up"):
            velocity.y = -1.0 * SPEED
        elif Input.is_action_pressed(player + "_move_down"):
            velocity.y = 1.0 * SPEED
        else:
            velocity.y = move_toward(velocity.y, 0.0, SPEED * 10 * delta)
            
            velocity.x = 0.0

        move_and_slide()
    else:
        frame_count += 1
        
        if not ball:
            return
            
        if ball.velocity.x > 0:
            var reaction_delay = int(lerp(60, 5, difficulty))
            if needs_new_prediction:
                if frame_count % reaction_delay == 0:
                    debug_points.clear() 
                    future_y = get_predicted_y_with_physics(ball)
                    # needs_new_prediction = false
        else:
            #needs_new_prediction = true
            future_y = get_viewport_rect().size.y / 2
        var distance = future_y - global_position.y
        
        # If we are far enough away, move
        if abs(distance) > 5.0:
            # Determine direction (-1 for up, 1 for down)
            var direction = sign(distance)
            velocity.y = direction * SPEED
        else:
            velocity.y = 0.0

        move_and_slide()


func get_predicted_y_with_physics(ball_local: Node2D) -> float:
    # 1. Get the Physics State (allows us to fire rays manually)
    var space_state = get_world_2d().direct_space_state
    
    # Start tracing from the ball's current position and direction
    var current_pos := ball_local.global_position
    var direction: Vector2 = ball_local.velocity.normalized()
    
    # We will loop to simulate bounces (max 3 bounces to prevent infinite loops)
    for i in range(3):
        # 2. Setup the Ray
        # Project the ray far out in the current direction
        var query = PhysicsRayQueryParameters2D.create(current_pos, current_pos + direction * 2000)
        
        # Don't let the ray hit the ball itself!
        query.exclude = [ball_local.get_rid()]
        
        query.collision_mask = 1
        # 3. Fire the Ray
        var result := space_state.intersect_ray(query)
        
        if result:
            var hit_pos: Vector2 = result["position"]
            var normal = result["normal"]
            
            debug_points.append(hit_pos)

            if current_pos.x < position.x and hit_pos.x >= position.x:
                var t := (position.x - current_pos.x) / (hit_pos.x - current_pos.x)
                var perfect_y: float = current_pos.y + t * (hit_pos.y - current_pos.y)
                
                var current_error_range = max_error_margin * (1.0 - difficulty)
                
                var random_offset = randf_range(-current_error_range, current_error_range)
                print(random_offset)
                return perfect_y + random_offset

            # Bounce normally if we haven't crossed the line yet
            direction = direction.bounce(normal)
            current_pos = hit_pos + (normal * 1.0)
        else:
            break

    return ball_local.global_position.y


func _on_node_2d_player_scored() -> void:
    difficulty = move_toward(difficulty, 1.0, 0.1)
    print("New Difficulty: " + str(difficulty))
