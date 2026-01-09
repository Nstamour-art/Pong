extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    $Ball.reset_ball()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass


func _on_player_1_zone_body_entered(body: Node2D) -> void:
    if body == $Ball:
        await get_tree().create_timer(0.5).timeout
        $Ball.reset_ball()
        

func _on_player_2_zone_body_entered(body: Node2D) -> void:
    if body == $Ball:
        await get_tree().create_timer(0.5).timeout
        $Ball.reset_ball()
