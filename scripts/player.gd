extends CharacterBody2D


const SPEED = 300.0
@export var player: String = "player_1"


func _physics_process(delta: float) -> void:
    # Get the input direction and handle the movement/deceleration.
    # As good practice, you should replace UI actions with custom gameplay actions.
    
    if Input.is_action_pressed(player + "_move_up"):
        velocity.y = -1.0 * SPEED
    elif Input.is_action_pressed(player + "_move_down"):
        velocity.y = 1.0 * SPEED
    else:
        velocity.y = move_toward(velocity.y, 0.0, SPEED * 10 * delta)
        
        velocity.x = 0.0

    move_and_slide()
