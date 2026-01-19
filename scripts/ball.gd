extends CharacterBody2D


@export var SPEED := 300.0
@export var SPEED_FACTOR := 50.0
@export var marker: Marker2D
var speed_modifier = SPEED

func _ready() -> void:
    reset_ball()


func reset_ball() -> void:
    position = marker.global_position
    
    speed_modifier = SPEED
    
    var direction: Vector2
    
    direction.x = [-1, 1].pick_random()
    direction.y = randf_range(-0.5, 0.5)
    
    velocity = direction.normalized() * SPEED


func _physics_process(delta: float) -> void:
    var collision = move_and_collide(velocity * delta)
    
    if collision:
        var collider = collision.get_collider()
        
        if collider.is_in_group("paddles"):
            var normal = collision.get_normal()
            
            if abs(normal.x) == 1.0:
                speed_modifier += SPEED_FACTOR
                var paddle_shape = collision.get_collider_shape()
                var paddle_height = paddle_shape.shape.height
                var relative_y = (global_position.y - collider.global_position.y) / (paddle_height / 2)
                
                var new_direction = Vector2(-sign(velocity.x), relative_y)
                velocity = new_direction.normalized() * speed_modifier
            else:
                velocity = velocity.bounce(collision.get_normal()).normalized() * speed_modifier
        else:
            velocity = velocity.bounce(collision.get_normal()).normalized() * speed_modifier