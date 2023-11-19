# Models the waves and the background ocean
# Credit: Pixelipy
extends Node2D

# Stiffness constant of waves
var waveStiffnessConst = 0.015
# Dampening constant of waves
var waveDampeningConst = 0.03
# Spread constant of waves
var waveSpreadConst = 0.002

#array of wave springs
var springs = []

var distBtwSprings = 32
var numOfSprings = 40
var waterLength = distBtwSprings * numOfSprings
var waterSpring = preload("res://Scenes/water_spring.tscn")

var waterDepth = 1000
var waterTargetHeight = global_position.y
var waterBottom = waterTargetHeight + waterDepth
@onready var waterShape = $Water

# Called when the node enters the scene tree for the first time.
func _ready():
	# loops thru all springs and initializes them
	for i in range(numOfSprings):
		var xPosSpring = distBtwSprings * i
		var waterSpringObj = waterSpring.instantiate()

		add_child(waterSpringObj)
		springs.append(waterSpringObj)
		waterSpringObj.initializeSpring(xPosSpring)
		
	createSplash(2, 5)
		

# Called during each frame
func _physics_process(delta):
	# updates water spring position for wave animation
	for i in springs:
		i.updateWater(waveStiffnessConst, waveDampeningConst)
	
	# difference in height between each spring and its left/right wave
	var leftWaveDeltas = []
	var rightWaveDeltas = []
	
	# initialize delta arrays with 0
	for i in range(springs.size()):
		leftWaveDeltas.append(0)
		rightWaveDeltas.append(0)
		pass
	
	# makes the wave move
	for i in range(springs.size()):
		if i > 0:
			leftWaveDeltas[i] = waveSpreadConst * (springs[i].currHeight - springs[i-1].currHeight)
			springs[i-1].currVelocity += leftWaveDeltas[i]
		if i < springs.size() - 1:
			rightWaveDeltas[i] = waveSpreadConst * (springs[i].currHeight - springs[i+1].currHeight)
			springs[i+1].currVelocity += rightWaveDeltas[i]
	drawOcean()
			
func createSplash(springIdx, springSpeed):
	if springIdx >= 0 and springIdx < springs.size():
		springs[springIdx].currVelocity += springSpeed
	pass
	
func drawOcean():
	var surfacePoints = []
	for i in range(springs.size()):
		surfacePoints.append(springs[i].position)
		
	var firstIndex = 0
	var lastIndex = surfacePoints.size()-1
	
	var waterPolygonPoints = surfacePoints
	waterPolygonPoints.append(Vector2(surfacePoints[lastIndex].x, waterBottom))
	waterPolygonPoints.append(Vector2(surfacePoints[firstIndex].x, waterBottom))
	
	waterPolygonPoints = PackedVector2Array(waterPolygonPoints)
	
	waterShape.set_polygon(waterPolygonPoints)
	pass

