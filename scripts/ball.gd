extends CharacterBody2D


@export var SPEED = 300.0


func reset_ball() -> void:
    position = get_viewport_rect().size / 2
    
    var x_dir = [-1, 1].pick_random()
    var y_dir = randf_range(-0.5, 0.5)
    
    velocity = Vector2(x_dir, y_dir).normalized() * SPEED


func _physics_process(delta: float) -> void:
    pass