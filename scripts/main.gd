extends Node2D

var PLAYER_SCORE: int = 0
@export var PLAYER_SCORE_COUNTER: Label

signal player_scored

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    $Ball.reset_ball()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    update_score()


func _on_player_1_zone_body_entered(body: Node2D) -> void:
    if body == $Ball:
        reset()
        

func _on_player_2_zone_body_entered(body: Node2D) -> void:
    if body == $Ball:
        reset()
        update_score()
        PLAYER_SCORE += 1
        player_scored.emit()
        


func reset() -> void:
    await get_tree().create_timer(0.5).timeout
    $Ball.reset_ball()

func update_score() -> void:
    PLAYER_SCORE_COUNTER.text = str(PLAYER_SCORE).pad_zeros(5)
