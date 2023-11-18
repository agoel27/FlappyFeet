extends Area2D
signal hit

@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
var tether_bool = false
var pos2 = Vector2.ZERO

func _ready():
	screen_size = get_viewport_rect().size
	hide()

func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	var move = 1
	if Input.is_action_pressed("move_right"):
		velocity.x += move
	if Input.is_action_pressed("move_left"):
		velocity.x -= move
	if Input.is_action_pressed("move_down"):
		velocity.y += move
	if Input.is_action_pressed("move_up"):
		velocity.y -= move
	
	if velocity.length() > 0:
		velocity = (velocity).normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false

func _on_body_entered(body):
	hide() # Player disappears after being hit.
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)

func hide_body():
	hide()
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos + Vector2(-30, 0)
	show()
	$CollisionShape2D.disabled = false
